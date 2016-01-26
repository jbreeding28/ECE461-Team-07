classdef DroneSystem
    %DRONESYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % c holds constants
        c;
        % initialize detector with a placeholder so that it can be made
        % into an array of detector objects later on
        detectors = Detector();
        localizer;
        audioRecorder;
    end
    
    methods
        function DS = DroneSystem(configSettings)
            DS.c = configSettings.constants;
            
            % initialize one detector for each channel
            for i = 1:DS.c.NUM_CHANNELS
                DS.detectors(i) = Detector(configSettings);
            end
            
            DS.audioRecorder = dsp.AudioRecorder('SamplesPerFrame', ...
                DS.c.FRAME_SIZE,'SampleRate',DS.c.Fs,'DeviceName', ...
                configSettings.audioDriver,'NumChannels', ...
                DS.c.NUM_CHANNELS);
        end
        
        % consider trying to make an event called stop
        
        function start(DS)
            decisions = {'1'; '2'; '3'; '4'};
            figure()
            % make text boxes for displaying the output of each detector
            % (and information relevant to testing)
            for i = 1:DS.c.NUM_CHANNELS
                hTextBox(i) = uicontrol('style','text');
                set(hTextBox(i),'String',decisions(i));
                set(hTextBox(i),'Position',[0 30*i 300 25])
            end
            
            while(1)
                audioFrame = step(DS.audioRecorder);
                for i = 1:DS.c.NUM_CHANNELS
                    decisions(i) = {DS.detectors(i).step(audioFrame(:,i))};
                    % decisions(i) = {};
                    stringOutput = [decisions{i}, ' E: ', ...
                        num2str(DS.detectors(i).getEnergy()), ' F: ', ...
                        num2str(DS.detectors(i).getFlux())];
                    set(hTextBox(i),'String',stringOutput);
                    
                    % WRITE CODE HERE TO PLOT WHERE THE THING IS IN SPACE
                end
                drawnow;
                
            end
        end
        
        function decisionNums = test(DS,singleAudioFrame)
            %TEST take a single audio frame and make a decision
            %   This function is meant to be called when there is a bunch
            %   of recorded data that the system is to be tested with.
            decisions = cell(DS.c.NUM_CHANNELS,1);
            decisionNums = zeros(DS.c.NUM_CHANNELS,1);
            for i = 1:DS.c.NUM_CHANNELS
                decisions(i) = {DS.detectors(i).step(singleAudioFrame(:,i))};
                decisionNums(i) = DS.classStringToNum(decisions(i));
            end
        end
        
        function calibration(DS)
            
        end
        
        function classNum = classStringToNum(DS,classString)
            if(strcmp('weak signal',classString))
                classNum = 1;
                return;
            elseif(strcmp('highly non-stationary signal',classString))
                classNum = 2;
                return;
            elseif(strcmp('non-drone oscillator signal',classString))
                classNum = 3;
                return;
            elseif(strcmp('drone signal',classString))
                classNum = 4;
                return;
            else
                warning('class string input does not match existing strings')
                classNum = -1;
            end
        end
        
    end
    
end

