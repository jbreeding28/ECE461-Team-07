classdef DroneSystem
    %DRONESYSTEM This class builds up a drone system
    %   Detailed explanation goes here
    
    properties
        % c holds constants
        c;
        % initialize detector with a placeholder so that it can be made
        % into an array of detector objects later on
        detectors = Detector();
        localiz;
        audioRecorder;
        F_AXIS;
    end
    
    methods
        function DS = DroneSystem(configSettings,kNNStuff)
            DS.c = configSettings.constants;
            DS.localiz = localizer;
            
            % initialize one detector for each channel
            for i = 1:DS.c.NUM_CHANNELS
                DS.detectors(i) = Detector(configSettings,kNNStuff);
            end
            
            DS.audioRecorder = dsp.AudioRecorder('SamplesPerFrame', ...
                DS.c.FRAME_SIZE,'SampleRate',DS.c.Fs,'DeviceName', ...
                configSettings.audioDriver,'NumChannels', ...
                DS.c.NUM_CHANNELS);
            
            DS.F_AXIS = linspace(0,DS.c.Fs/2,DS.c.WINDOW_SIZE/2+1);
        end
        
        % consider trying to make an event called stop
        
        function start(DS)
            % setup the live plots
            decisions = {'1'; '2'; '3'; '4'};
            
            [hFig, hp, ha, hTextBox, hIm] = DS.figureSetup(decisions);
            
            numPointsFeatureSpace = 100;
            
            % features over time
            energies = zeros(numPointsFeatureSpace,1);
            fluxes = zeros(numPointsFeatureSpace,1);
            zcrs = zeros(numPointsFeatureSpace,1);
            f0s = zeros(numPointsFeatureSpace,1);
            spectra = zeros(numPointsFeatureSpace, DS.c.WINDOW_SIZE/2+1);
            
            amplitudes = zeros(1,DS.c.NUM_CHANNELS);
            raw_locationBuffer = zeros(1,10);
            avg_locations = zeros(1,10);
            load('image_config.mat');
            % eventually, put the below line in the if statement below
            DS.localiz.configImViewer(hIm);
            if(DS.c.NUM_CHANNELS==4)
                disp('Four input channels detected, localizer active')
                fourChannelMode = 1;
            else
                disp([num2str(DS.c.NUM_CHANNELS) ...
                    ' input channel(s) detected, 4 required for localize to go active'])
                fourChannelMode = 0;
            end
            
            % MAIN LOOP
            while(1)
            try
                audioFrame = step(DS.audioRecorder);
                for i = 1:DS.c.NUM_CHANNELS
                    decisions(i) = {DS.detectors(i).step(audioFrame(:,i))};
                    amplitudes(i) = DS.detectors(i).getDroneAmplitude();
                    stringOutput = [decisions{i}, ' E: ', ...
                        num2str(DS.detectors(i).getEnergy()), ' F: ', ...
                        num2str(DS.detectors(i).getFlux()), ' f0: ', ...
                        num2str(DS.detectors(i).getf0()), ' zcr: ' ...
                        num2str(DS.detectors(i).getZCR())];
                    set(hTextBox(i),'String',stringOutput);
                end
                energies = [DS.detectors(1).getEnergy; ...
                    energies(1:(numPointsFeatureSpace-1))];
                f0s = [DS.detectors(1).getf0;f0s(1:(numPointsFeatureSpace-1))];
                fluxes = [DS.detectors(1).getFlux; ...
                    fluxes(1:(numPointsFeatureSpace-1))];
                zcrs = [DS.detectors(1).getZCR; ...
                    zcrs(1:(numPointsFeatureSpace-1))];
                spectra = [DS.detectors(1).getPreviousSpectrum()'; ...
                    spectra(1:(numPointsFeatureSpace-1),:)];
                
%                 set(hp(1),'YData',DS.detectors(1).getEnergy(),'XData',...
%                     DS.detectors(i).getFlux());
%                 set(hp(2),'YData',DS.detectors(1).getPreviousSpectrum());
                
                set(hp(1),'YData',f0s,'XData', fluxes,'ZData',zcrs);
                set(hp(2),'XData',DS.F_AXIS,'YData',...
                   DS.detectors(1).getPreviousSpectrum());
                drawnow;
                
                % if there is a complete setup, run the localizer
                if(fourChannelMode)
                   [location, A] = DS.localiz.direction(amplitudes(1),...
                       amplitudes(2),amplitudes(3),amplitudes(4));
                    raw_locationBuffer(2:end) = raw_locationBuffer...
                        (1:end-1);
                    raw_locationBuffer(1) = location;

                    points_to_avg=5;
                    avg_loc=DS.localiz.averager(raw_locationBuffer...
                        (1:points_to_avg));
                    avg_locations(2:end)=avg_locations(1:end-1);
                    avg_locations(1)=avg_loc;

                    DS.localiz.display2(avg_locations,A,bckgrnd,Czone,...
                        NNEzone,ENEzone,ESEzone,SSEzone,SSWzone,WSWzone,...
                        WNWzone,NNWzone,nodrone);
                end
            catch ME
                DS.localiz.historyToWorkspace();
                rethrow(ME);
            end
            
            end
        end
        
        function [decisionNums,fluxes,energies] = test(DS,singleAudioFrame)
            %TEST take a single audio frame and make a decision
            %   This function is meant to be called when there is a bunch
            %   of recorded data that the system is to be tested with.
            decisions = cell(DS.c.NUM_CHANNELS,1);
            decisionNums = zeros(DS.c.NUM_CHANNELS,1);
            fluxes = zeros(DS.c.NUM_CHANNELS,1);
            energies = zeros(DS.c.NUM_CHANNELS,1);
            for i = 1:DS.c.NUM_CHANNELS
                decisions(i) = {DS.detectors(i).step(singleAudioFrame...
                    (:,i))};
                decisionNumbers(i) = DS.classStringToNum(decisions(i));
                fluxes(i) = DS.detectors(i).getFlux();
                energies(i) = DS.detectors(i).getEnergy();
            end
            decisionNums = {decisionNumbers};
        end
        
%         function localizerStep(DS,Af1,Af2,Af3,Af4)
%             DS.localiz.direction()
%         end
  
        function localizerTest(DS,Af)
           % A = zeros(1,DS.c.NUM_CHANNELS);
%             for i = 1:DS.c.NUM_CHANNELS
%                 %DS.detectors(i) = Detector(configSettings);
%                 DS.detectors(i).step(Af(:,i));
%                 A(i) = DS.detectors(i).dronePresent(DS.detectors(i).previousSpectrum);
%             end
            A1 = sum(abs(Af(:,1)));
            A2 = sum(abs(Af(:,2)));
            A3 = sum(abs(Af(:,3)));
            A4 = sum(abs(Af(:,4)));

            mval = max([A1 A2 A3 A4]);
            A1 = A1/mval;
            A2 = A2/mval;
            A3 = A3/mval;
            A4 = A4/mval;
            DS.localiz.direction(A1,A2,A3,A4);
        end
        
        function [hFig, hp, ha, hTextBox, hIm] = figureSetup(DS, decisions)
        %FIGURESETUP a function used to setup a figure for testing purposes
            hFig = figure();
            subplot(2,1,1);
            % 2D plot
%             hp(1) = plot(1,1,'O');
%             axis manual
%             ha(1) = gca;
%             set(ha(1),'YLimMode','manual')
% %             set(ha(1),'YLim',[0 1000],'YScale','log','XLim',[0 1], ...
% %                 'XScale','log')
%             % this is a line of great interest when calibrating with the
%             % hardware
%             set(ha(1),'YLim',[0 1000],'XLim',[0 0.02])
            
            % 3D plot
            hp(1) = plot3(1,1,1,'O');
            grid on
            ha(1) = gca;
            xlabel('Normalized spectral flux')
            ylabel('Fundemental frequency (Hz)')
            zlabel('Zero crossing rate')
            
            title('Feature space')
            
            subplot(2,1,2);
            hp(2) = plot(DS.F_AXIS,zeros(1,DS.c.WINDOW_SIZE/2+1));
            ha(2) = gca;
            set(ha(2),'YLimMode','manual')
            set(ha(2),'YLim',[0 2],'XLim',[150 20E3])
            set(ha(2),'Xscale','log')
            title('Current spectrum')
            
            % text boxes for displaying the output of each detector
            % (and information relevant to testing)
            for i = 1:DS.c.NUM_CHANNELS
                hTextBox(i) = uicontrol('style','text');
                set(hTextBox(i),'String',decisions(i));
                set(hTextBox(i),'Position',[0 30*i 300 25])
            end
            
            % localizer image
            figure
            hIm = imshow(zeros(501,501,3));
        end
        
        function calibration(DS)
            % potentially something to implement in the future
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