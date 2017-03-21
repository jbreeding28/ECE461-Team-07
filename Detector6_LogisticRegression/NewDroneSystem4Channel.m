classdef NewDroneSystem4Channel
    %NEWDRONESYSTEM4CHANNEL This class builds a drone system.
    % This class is the main function of the code.
    % It is set up to work with four microphones.
    
    properties
        % c holds constants
        c;
        % B holds the logistic regression model
        B;
        % Boffset holds just the initial offset for the model
        Boffset;
        % Bslopes holds the multipliers for each feature
        Bslopes;
        % cutoff holds the cutoff accuracy for drones
        cutoff;
        % class0Data holds all of the feature data
        % for the Class 0 (non-drone) data taken from the signal profiles
        class0Data;
        % class1Data holds all of the feature data
        % for the Class 1 (drone) data taken from the signal profiles
        class1Data;
        % initialize detector with a placeholder so that it can be made
        % into an array of detector objects later on
        detectors = featureDetection();
        % probabilityCutoff is the dividing probability
        % between the two classes.
        probabilityCutoff;
        % the percentage of data used to build the model
        modelPercentage
        % a matrix holding the most current features from each microphone
        features;
        % the device which receives the audio from the mixer and processes
        % it into MATLAB
        audioRecorder;
        % The frequency axis for frequency spectrum plots
        F_AXIS;
        % tells the program to keep running or shut down
        shutdown;
        % holds previous detections by microphones to prevent sporadic
        % dropouts of detection
        detectionHistory;
        % the minimum percentage of detection needed in detectionHistory to
        % qualify as detection
        historyDetectionMinimum;
        % the initial zone where the drone is detected
        initialZone;
        % the current zone where the drone is detected
        finalZone;
        % the current and previous zone detections
        zoneHistory;
        % length of zone history
        zoneHistoryLength;
        % the current heading of the drone
        heading;
    end
    
    methods
        function DS = NewDroneSystem4Channel(configSettings,kNNStuff)
            DS.historyDetectionMinimum = 0.2;
            DS.initialZone = 0;
            DS.finalZone = 0;
            DS.zoneHistoryLength = 4;
            DS.zoneHistory = zeros(DS.zoneHistoryLength,1);
            % All the zones are set to -1 so they don't show up on the GUI
            DS.zoneHistory = DS.zoneHistory - 1;
            %[pathname,dirname] = uigetfile('*.mat','Select database file');
            %fullpath = fullfile(dirname,pathname);
            %try
            %    if(pathname == 0 && dirname == 0)
            %        DS.shutdown = 1;
            %        return;
            %    end
            %end
            %uiopen(fullpath,true);
            
            % This creates and returns the .mat file to use for the
            % database
            fileName = CreateModelDataPacket();
            
            % This pulls up a dialog window to establish the cutoff
            % probability and percentage of data used to build the model.
            try
                load(cast(fileName,'char'));
            catch ERROR
                return;
            end
            prompt = {'Enter detection probability cutoff (0 to 1)',...
                'Enter model data fraction (0 to 1)'};
            title = 'Model Building Parameters';
            num_lines = 1;
            default_detection_prob = 0.8;
            default_modelbuild_fraction = 0.5;
            default_ans = {num2str(default_detection_prob),num2str(default_modelbuild_fraction)};
            successful = false;
            while(~successful)
            % the dialog window is generated with defaults
            answer = inputdlg(prompt,title,num_lines,default_ans);
            try
                % once the dialog is answered, the answers are extracted
                % and converted to numbers
                answerDouble = str2double(answer);
                % checks to make sure both numbers are between 1 and 0
                lessThanOne = answerDouble <= 1;
                greaterThanZero = answerDouble > 0;
                both = lessThanOne .* greaterThanZero;
                % sets the values and breaks the loop if both pass
                if(all(both))
                    successful = 1;
                    DS.probabilityCutoff = answerDouble(1);
                    DS.modelPercentage = answerDouble(2);
                else
                    disp('Error. Values must be numbers between 0 and 1');
                end
            catch ERROR
                disp('Error. Values must be numbers between 0 and 1');
            end;
            if(isempty(answer))
                DS.shutdown = 1;
                return;
            end
            end
            %load('DataCollection_1_18_2017.mat');
            % sets up the detection history vector
            % this holds the history of detection for a given number of
            % detection cycles
            detectionHistoryLength = 5;
            DS.c = configSettings.constants;
            DS.detectionHistory = zeros(detectionHistoryLength,DS.c.NUM_CHANNELS);
            DS.shutdown = 0;
            % Extracts and formats the 
            % DS.localiz = localizer;
            classes = ClassNumber;
            %features = double(DominantFrequencyValue);
            modelFeatures = horzcat(double(DominantFrequency),double(SecondHighestFrequency),...
                double(DominantFrequencyValue),...
                double(SecondHighestFrequencyValue),...
                double(Energy),...
                double(SilencePercentage));
            
            %    double(SpectrumCentroid));
            % goes through the data to separate it into Class 1 and Class 0
            % this assumes the data is formatted so that all Class 0 data
            % is at the top
            class0Endpoint = 1;
            for n = 1:length(classes)
                if(~eq(classes(n),classes(1)))
                    class0Endpoint = n - 1;
                    break;
                end
            end
            %modelPercentage = 0.5;
            %DS.probabilityCutoff = 0.65;
            % number of runs the model-building algorithm goes through
            modelRuns = 30;

            DS.class0Data = modelFeatures(1:class0Endpoint,:);
            DS.class1Data = modelFeatures(class0Endpoint + 1:size(modelFeatures,1),:);
            % This runs the model generation algorithm multiple times and
            % returns the best algorithm for the system to use
            [B, dev, stats, accuracy] = ...
                generateSystemModel(DS.class1Data, DS.class0Data,...
                DS.modelPercentage, DS.probabilityCutoff, modelRuns)
            DS.B = B;
            DS.Boffset = B(1);
            DS.Bslopes = B(2:length(DS.B));
            %DS.cutoff = probabilityCutoff;
            % initialize one detector for each channel
            DS.features = zeros(size(modelFeatures,2),DS.c.NUM_CHANNELS);
            % initializes the four detectors, 1 for each channel
            for i = 1:DS.c.NUM_CHANNELS
                DS.detectors(i) = featureDetection(configSettings,kNNStuff);
            end
            % initializes the connection with the mixer
            % this sets the mixer as the audio source, and the number of
            % channels to listen to.
            DS.audioRecorder = dsp.AudioRecorder('SamplesPerFrame', ...
                DS.c.FRAME_SIZE,'SampleRate',DS.c.Fs,'DeviceName', ...
                configSettings.audioDriver,'NumChannels', ...
                DS.c.NUM_CHANNELS);
            %DS.audioRecorder = dsp.AudioRecorder('SamplesPerFrame', ...
            %    DS.c.FRAME_SIZE,'SampleRate',DS.c.Fs,'NumChannels', ...
            %    DS.c.NUM_CHANNELS);
            
            
            DS.F_AXIS = linspace(0,DS.c.Fs/2,DS.c.WINDOW_SIZE/2+1);
        end
        
        % consider trying to make an event called stop
        
        % The main function, which starts detection and runs until the
        % program is shut down
        function start(DS)
            % setup the live plots
            
            [hFig, hp, ha] = DS.figureSetup();
            GUI = locatorGUI();
            hLoc = GUI.initialize();
            
            % features over time
            load('image_config.mat');
            % eventually, put the below line in the if statement below
            % DS.localiz.configImViewer(hIm);
            decisions = zeros(4,1);
            shutdown = 0;
            previousDetection = false;
            % The main loop of the program
            % This runs continuously until shutdown = 1
            while(~shutdown)
            try
                %audioFrame = fliplr(step(DS.audioRecorder));
                % an audio frame of 2048 samples is brought in
                audioFrame = step(DS.audioRecorder);
                getFeatures = false(DS.c.NUM_CHANNELS,1);
                relativeProbs = zeros(DS.c.NUM_CHANNELS,1);
                probs = zeros(DS.c.NUM_CHANNELS,1);
                pwrs = zeros(DS.c.NUM_CHANNELS,1);
                updateDetection = false;
                % this loop updates detection for each microphone
                for i = 1:DS.c.NUM_CHANNELS
                    getFeatures(i) = DS.detectors(i).step(audioFrame(:,i));
                    %getFeatures is a variable signalling to update
                    %detection
                    if getFeatures(i)
                        updateDetection = true;
                        % return the features for the current microphone
                        DS.features(:,i) = DS.detectors(i).getFeatures();
                        % calculate drone probability
                        relativeProbs(i) = exp(DS.Boffset + sum(DS.Bslopes.*DS.features(:,i)));
                        % Prevents "infinite" relative probability from
                        % screwing up probability
                        if isinf(relativeProbs(i))
                            probs(i) = 1;
                        else
                            probs(i) = relativeProbs(i)./(1+relativeProbs(i));
                        end
                        % Returns the decibel power of the microphone
                        pwrs(i) = DS.detectors(i).getPwrDB();
                        % decides for each microphone if a drone is present
                        decisions(i) = probs(i) >= DS.probabilityCutoff;
                        decisionHistoryShifted = circshift(DS.detectionHistory(:,i),1);
                        decisionHistoryShifted(1) = decisions(i);
                        DS.detectionHistory(:,i) = decisionHistoryShifted;
                    end
                end
                % Updates direction finding if a drone is detected
                if updateDetection
                    % locates the drone
                    [zone, compass] = directionFinder(pwrs);
                    %returns if a drone was detected this past cycle or if
                    %previous detections are keeping detection in place
                    [oldDrone, currentDrone] = DS.newDroneDecision();
                    droneDetected = false;
                    if(oldDrone || previousDetection)
                        %disp('Old drone detected');
                        % updates final zone if it's an old drone
                        previousDetection = currentDrone;
                        DS.finalZone = zone;
                        DS.zoneHistory = circshift(DS.zoneHistory,[-1,0]);
                        DS.zoneHistory(DS.zoneHistoryLength) = zone;
                        droneDetected = true;
                        % database match code is commented out because it
                        % doesn't work.
                        % DS.databaseMatch();
                        %heading = headingDetector(DS.initialZone, DS.finalZone);
                        %disp(heading);
                    elseif(currentDrone)
                        %disp('New drone detected');
                        % initializes the GUI if a new drone is detected
                        previousDetection = true;
                        DS.initialZone = zone;
                        DS.zoneHistory(DS.zoneHistoryLength) = zone;
                        droneDetected = true;
                        %[maxProb, maxProbIndex] = max(probs);
                        
                    else
                        %disp('No drone detected');
                        previousDetection = false;
                        DS.initialZone = 0;
                        DS.finalZone = 0;
                        DS.zoneHistory = circshift(DS.zoneHistory,[-1,0]);
                        DS.zoneHistory(DS.zoneHistoryLength) = -1;
                        droneDetected = false;
                    end
                    DS.heading = headingDetector(DS.initialZone,DS.finalZone);
                    % after everything is calculated, 
                    hLoc = GUI.update(DS.zoneHistory,DS.heading,droneDetected,hLoc);
                end
                % Updates the four microphone plots
                for i = 1:DS.c.NUM_CHANNELS
                set(hp(i),'XData',DS.F_AXIS,'YData',...
                   DS.detectors(i).getPreviousSpectrum());
                drawnow;
                end
                % set shutdown to 1 if the shutdown button is pressed
                shutdown = getappdata(hFig,'shutdown');
                
                % if there is a complete setup, run the localizer
            catch ME
                % DS.localiz.historyToWorkspace();
                rethrow(ME);
            end
            
            end
            
            % Closes both figures
            close(gcf);
            close(gcf);
        end
        
%         function localizerStep(DS,Af1,Af2,Af3,Af4)
%             DS.localiz.direction()
%         end 

        function [hFig, hp, ha,hLoc] = figureSetup(DS)
            hFig = figure();
            setappdata(hFig,'shutdown',0);
            subplot(2,2,1);            
            hp(1) = plot(DS.F_AXIS,zeros(1,DS.c.WINDOW_SIZE/2+1));
            ha(1) = gca;
            set(ha(1),'YLimMode','manual');
            set(ha(1),'YLim',[0 3],'XLim',[0 20E3]);
            set(ha(1),'Xscale','log');
            title('Microphone 1');
            subplot(2,2,2);            
            hp(2) = plot(DS.F_AXIS,zeros(1,DS.c.WINDOW_SIZE/2+1));
            ha(2) = gca;
            set(ha(2),'YLimMode','manual');
            set(ha(2),'YLim',[0 3],'XLim',[0 20E3]);
            set(ha(2),'Xscale','log');
            title('Microphone 2');
            subplot(2,2,3);            
            hp(3) = plot(DS.F_AXIS,zeros(1,DS.c.WINDOW_SIZE/2+1));
            ha(3) = gca;
            set(ha(3),'YLimMode','manual');
            set(ha(3),'YLim',[0 3],'XLim',[0 20E3]);
            set(ha(3),'Xscale','log');
            title('Microphone 3');
            subplot(2,2,4);            
            hp(4) = plot(DS.F_AXIS,zeros(1,DS.c.WINDOW_SIZE/2+1));
            ha(4) = gca;
            set(ha(4),'YLimMode','manual');
            set(ha(4),'YLim',[0 3],'XLim',[0 20E3]);
            set(ha(4),'Xscale','log');
            title('Microphone 4');

            %for i = 1:DS.c.NUM_CHANNELS
            %    hTextBox(i) = uicontrol('style','text');
            %    set(hTextBox(i),'String',decisions(i));
            %    set(hTextBox(i),'Position',[0 30*i 300 25])
            %end
            % a close button put on the GUI to properly close out the
            % program.
            closeButton = uicontrol('Style','pushbutton','String','Close',...
                'Position',[500,5,50,20],'Callback', @closeWindow_Callback);
            % sets the overall shutdown variable to 1 so that the program
            % closes out properly.
            function closeWindow_Callback(hObject, eventdata)
                setappdata(hObject.Parent, 'shutdown', 1);
            end
            
            % localizer image
            %figure
            %hIm = imshow(zeros(501,501,3));
        end
        
        % This function determines if the drone detected is currently being
        % detected, as well as if the history matrix is filled up enough to
        % carry the detection through a dip.
        function [oldDrone currentDrone] = newDroneDecision(DS)
            % the previous detections for the four microphones
            oldHistory = DS.detectionHistory(2:size(DS.detectionHistory,1),:);
            % the most recent detection for each mic
            currentHistory = DS.detectionHistory(1,:);
            % if any mic is currently detecting a drone, say it's current
            currentDrone = any(currentHistory);
            numberOfOldDetections = sum(sum(oldHistory));
            [dim1 dim2] = size(DS.detectionHistory);
            oldHistorySize = dim1 * dim2;
            % check to see if enough detections are contained in the buffer
            oldDrone = numberOfOldDetections/oldHistorySize >= DS.historyDetectionMinimum;
            
        end
        
        % a function that attempts to match a current audio signal to drone
        % signals already in the database.
        % This function specifies tolerance for all of the features and
        % compares the features against all the feature sets in the
        % database to see if they match. If enough of the features match,
        % it is said to be the same drone.
        
        % This function is not currently implemented. While the code works,
        % this method does not seem to work at properly identifying drones
        function databaseMatch(DS)
            waveform = zeros(size(DS.detectors(1).getBufferedAudio,1),DS.c.NUM_CHANNELS);
            transform = zeros(size(waveform));
            DominantPeakFreqTolerance = 500; %tolerance range in Hz b/c percent difference in the frequency spectrum can vary with frequency
            SecondPeakFreqTolerance = 500; %tolerance range in Hz b/c percent difference in the frequency spectrum can vary with frequency
            percentTolerance = 0.15; % 5 percent tolerance
            matchPercentage = 0.8; % 80 percent matching tolerance
            
            % percent difference calculations. Then calculations are done
            % to see if everything is within tolerance
            for i = 1:DS.c.NUM_CHANNELS
                waveform(:,i) = DS.detectors(i).getBufferedAudio;
                transform(:,i) = DS.detectors(i).getTransform;
                currentFeatures = DS.features(:,i)';
                currentFeatureMatrix = repmat(currentFeatures,size(DS.class1Data,1),1);
                featureDifferences = abs(currentFeatureMatrix - DS.class1Data);
                percentDifferences = abs(featureDifferences./currentFeatureMatrix);
                withinTolerance(:,1) = featureDifferences(:,1) <= DominantPeakFreqTolerance;
                withinTolerance(:,2) = featureDifferences(:,2) <= SecondPeakFreqTolerance;
                withinTolerance(:,3:6) = percentDifferences(:,3:6) <= percentTolerance; % 5 percent tolerance
                rowPercentMatch = mean(withinTolerance,2);
%                 rowMatch = all(withinTolerance,2);
%                 match = any(rowMatch);
                percentMatch = rowPercentMatch >= matchPercentage;
                match = any(percentMatch);
                if(match)
                    disp('Drone already exists in database');
                else
                    disp('Drone does not exist in database');
                    % create a new signal profile for the data
                    %CreateSignalProfile(waveform, 44100, transform)
                end
            end
        end
        
        function calibration(DS)
            % potentially something to implement in the future
        end
        
 
        
    end
    
end