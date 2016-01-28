classdef DroneSystem
    %DRONESYSTEM This class builds up a drone system
    %   Detailed explanation goes here
    
    properties
        % c holds constants
        c;
        % initialize detector with a placeholder so that it can be made
        % into an array of detector objects later on
        detectors = Detector();
        localizer;
        audioRecorder;
        testVariable;
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
            
            DS.testVariable = zeros(2049,1);
        end
        
        % consider trying to make an event called stop
        
        function start(DS)
            % setup the live plots
            decisions = {'1'; '2'; '3'; '4'};
            
            % [hFig hp ha] = figureSetup();
            hFig = figure();
            subplot(2,1,1);
            hp(1) = plot(1,1,'O');
            axis manual
            ha(1) = gca;
            set(ha(1),'YLimMode','manual')
%             set(ha(1),'YLim',[0 1000],'YScale','log','XLim',[0 1], ...
%                 'XScale','log')
            
            % this is a line of great interest when calibrating
            set(ha(1),'YLim',[0 1000],'XLim',[0 0.02])

            
            title('Feature space')
            subplot(2,1,2);
            hp(2) = plot(zeros(DS.c.FRAME_SIZE,1)');
            ha(2) = gca;
            set(ha(2),'YLimMode','manual')
            title('Current spectrum')
            
            % text boxes for displaying the output of each detector
            % (and information relevant to testing)
            for i = 1:DS.c.NUM_CHANNELS
                hTextBox(i) = uicontrol('style','text');
                set(hTextBox(i),'String',decisions(i));
                set(hTextBox(i),'Position',[0 30*i 300 25])
            end
            
            % MAIN LOOP
            while(1)
                audioFrame = step(DS.audioRecorder);
                for i = 1:DS.c.NUM_CHANNELS
                    decisions(i) = {DS.detectors(i).step(audioFrame(:,i))};
                    % decisions(i) = {};
                    stringOutput = [decisions{i}, ' E: ', ...
                        num2str(DS.detectors(i).getEnergy()), ' F: ', ...
                        num2str(DS.detectors(i).getFlux())];
                    set(hTextBox(i),'String',stringOutput);
                end
                set(hp(1),'YData',DS.detectors(1).getEnergy(),'XData',...
                    DS.detectors(i).getFlux());
                set(hp(2),'YData',DS.detectors(1).getPreviousSpectrum());
                drawnow;
                DS.testVariable = DS.detectors(1).getPreviousSpectrum();
                
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
        
        function [hFig, hp, ha] = figureSetup(D)
        %FIGURESETUP a function used to setup a figure for testing purposes
            
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

