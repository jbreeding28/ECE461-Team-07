classdef NewDroneSystem4Channel
    %NEWDRONESYSTEM This class builds up a drone system
    %   Detailed explanation goes here
    
    properties
        % c holds constants
        c;
        % B holds the logistic regression model
        B;
        Boffset;
        Bslopes;
        % cutoff holds the cutoff accuracy for drones
        cutoff;
        % initialize detector with a placeholder so that it can be made
        % into an array of detector objects later on
        detectors = featureDetection();
        probabilities;
        droneProbabilityCutoff;
        features;
        localiz;
        audioRecorder;
        F_AXIS;
        data;
        shutdown;
    end
    
    methods
        function DS = NewDroneSystem4Channel(configSettings,kNNStuff)
            load('AnechoicTestingData.mat');
            DS.c = configSettings.constants;
            DS.shutdown = 0;
            % DS.localiz = localizer;
            classes = ClassNumber;
            %features = double(DominantFrequencyValue);
            modelFeatures = horzcat(double(DominantFrequency),double(DominantFrequencyValue));
            DS.features = zeros(size(modelFeatures,2),DS.c.NUM_CHANNELS);
            %    double(SpectrumCentroid));
            class0Endpoint = 1;
            for n = 1:length(classes)
                if(~eq(classes(n),classes(1)))
                    class0Endpoint = n - 1;
                    break;
                end
            end
            modelPercentage = 0.5;
            probabilityCutoff = 0.65;
            DS.droneProbabilityCutoff = 0.65;
            modelRuns = 10;

            class0Data = modelFeatures(1:class0Endpoint,:);
            class1Data = modelFeatures(class0Endpoint + 1:size(modelFeatures,1),:);
            [B, dev, stats, accuracy] = ...
                generateSystemModel(class1Data, class0Data,...
                modelPercentage, probabilityCutoff, modelRuns)
            DS.B = B;
            DS.Boffset = B(1);
            DS.Bslopes = B(2:length(DS.B));
            DS.cutoff = probabilityCutoff;
            % initialize one detector for each channel
            for i = 1:DS.c.NUM_CHANNELS
                DS.detectors(i) = featureDetection(configSettings,kNNStuff);
            end
            
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
        
        function start(DS)
            % setup the live plots
            decisions = {'1'; '2'; '3'; '4'};
            
            [hFig, hp, ha, hTextBox] = DS.figureSetup(decisions);
            
            numPointsFeatureSpace = 100;
            
            % features over time
            load('image_config.mat');
            % eventually, put the below line in the if statement below
            % DS.localiz.configImViewer(hIm);
            % MAIN LOOP
            shutdown = 0;
            while(~shutdown)
            try
                audioFrame = step(DS.audioRecorder);
                getFeatures = false(DS.c.NUM_CHANNELS,1);
                relativeProbs = zeros(DS.c.NUM_CHANNELS,1);
                probs = zeros(DS.c.NUM_CHANNELS,1);
                pwrs = zeros(DS.c.NUM_CHANNELS,1);
                for i = 1:DS.c.NUM_CHANNELS
                    getFeatures(i) = DS.detectors(i).step(audioFrame(:,i));
                    if getFeatures(i)
                        DS.features(:,i) = DS.detectors(i).getFeatures();
                        relativeProbs(i) = exp(DS.Boffset + sum(DS.Bslopes.*DS.features(:,i)));
                        if isinf(relativeProbs(i))
                            probs(i) = 1;
                        else
                            probs(i) = relativeProbs(i)./(1+relativeProbs(i));
                        end
                        pwrs(i) = DS.detectors(i).getPwrDB();
                        %stringOutput = DS.shutdown;
                        stringOutput = [num2str(probs(i)) '    ' num2str(pwrs(i))];
                        set(hTextBox(i),'String',stringOutput);
                    end
                end
                %decision = droneDecision(DS.probabilities);
                for i = 1:DS.c.NUM_CHANNELS
                set(hp(i),'XData',DS.F_AXIS,'YData',...
                   DS.detectors(i).getPreviousSpectrum());
                drawnow;
                end
                
                shutdown = getappdata(hFig,'shutdown');
                
                % if there is a complete setup, run the localizer
            catch ME
                % DS.localiz.historyToWorkspace();
                rethrow(ME);
            end
            
            end
            
            close(gcf);
        end
        
%         function localizerStep(DS,Af1,Af2,Af3,Af4)
%             DS.localiz.direction()
%         end 

        function [hFig, hp, ha, hTextBox] = figureSetup(DS, decisions)
            hFig = figure();
            setappdata(hFig,'shutdown',0);
            subplot(2,2,1);            
            hp(1) = plot(DS.F_AXIS,zeros(1,DS.c.WINDOW_SIZE/2+1));
            ha(1) = gca;
            set(ha(1),'YLimMode','manual');
            set(ha(1),'YLim',[0 40],'XLim',[0 20E3]);
            set(ha(1),'Xscale','log');
            title('Microphone 1');
            subplot(2,2,2);            
            hp(2) = plot(DS.F_AXIS,zeros(1,DS.c.WINDOW_SIZE/2+1));
            ha(2) = gca;
            set(ha(2),'YLimMode','manual');
            set(ha(2),'YLim',[0 40],'XLim',[0 20E3]);
            set(ha(2),'Xscale','log');
            title('Microphone 2');
            subplot(2,2,3);            
            hp(3) = plot(DS.F_AXIS,zeros(1,DS.c.WINDOW_SIZE/2+1));
            ha(3) = gca;
            set(ha(3),'YLimMode','manual');
            set(ha(3),'YLim',[0 40],'XLim',[0 20E3]);
            set(ha(3),'Xscale','log');
            title('Microphone 3');
            subplot(2,2,4);            
            hp(4) = plot(DS.F_AXIS,zeros(1,DS.c.WINDOW_SIZE/2+1));
            ha(4) = gca;
            set(ha(4),'YLimMode','manual');
            set(ha(4),'YLim',[0 40],'XLim',[0 20E3]);
            set(ha(4),'Xscale','log');
            title('Microphone 4');
            for i = 1:DS.c.NUM_CHANNELS
                hTextBox(i) = uicontrol('style','text');
                set(hTextBox(i),'String',decisions(i));
                set(hTextBox(i),'Position',[0 30*i 300 25])
            end
            
            closeButton = uicontrol('Style','pushbutton','String','Close',...
                'Position',[500,5,50,20],'Callback', @closeWindow_Callback);
            
            function closeWindow_Callback(hObject, eventdata)
                setappdata(hObject.Parent, 'shutdown', 1);
            end
            
            % localizer image
            %figure
            %hIm = imshow(zeros(501,501,3));
        end
        
        
        function decision = droneDecision(DS, probabilities)
            decision = any(probabilityClassification(probabilities),1);
        end
        
        function decisions = probabilityClassifictaion(DS, probabilities)
            decisions = (probabilities >= DS.droneProbabilityCutoff);
        end
        
        function calibration(DS)
            % potentially something to implement in the future
        end
        
    end
    
end