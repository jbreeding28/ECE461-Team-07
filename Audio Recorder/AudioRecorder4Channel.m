classdef AudioRecorder4Channel
    %NEWDRONESYSTEM This class builds up a drone system
    %   Detailed explanation goes here
    
    properties
        % c holds constants
        c;
        % B holds the logistic regression model
        % initialize detector with a placeholder so that it can be made
        % into an array of detector objects later on
        recorders = AudioHolder();
        localiz;
        audioRecorder;
        F_AXIS;
        data;
        shutdown;
    end
    
    methods
        function DS = AudioRecorder4Channel(configSettings,kNNStuff)
            DS.shutdown = 0;
            DS.c = configSettings.constants;
            % DS.localiz = localizer;
            DS.c.NUM_CHANNELS = 4;
            % initialize one detector for each channel
            for i = 1:DS.c.NUM_CHANNELS
                DS.recorders(i) = AudioHolder(configSettings,kNNStuff);
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
            
            [hFig, hp, ha] = DS.figureSetup();
            
            
            % features over time
            load('image_config.mat');
            % eventually, put the below line in the if statement below
            % DS.localiz.configImViewer(hIm);
            
            % MAIN LOOP
            while(~DS.shutdown)
            try
                audioFrame = step(DS.audioRecorder);
                for i = 1:DS.c.NUM_CHANNELS
                    DS.recorders(i).step(audioFrame(:,i));
                    %stringOutput = [prob];
                    %set(hTextBox(i),'String',stringOutput);
                end
%                 set(hp(1),'YData',DS.detectors(1).getEnergy(),'XData',...
%                     DS.detectors(i).getFlux());
%                 set(hp(2),'YData',DS.detectors(1).getPreviousSpectrum());
                
                %set(hp(1),'YData',f0s,'XData', fluxes,'ZData',zcrs);
                set(hp(1),'XData',DS.F_AXIS,'YData',...
                   DS.recorders(1).getPreviousSpectrum());
                drawnow;
                set(hp(2),'XData',DS.F_AXIS,'YData',...
                   DS.recorders(2).getPreviousSpectrum());
                drawnow;
                set(hp(3),'XData',DS.F_AXIS,'YData',...
                   DS.recorders(3).getPreviousSpectrum());
                drawnow;
                set(hp(4),'XData',DS.F_AXIS,'YData',...
                   DS.recorders(4).getPreviousSpectrum());
                drawnow;
                
                % if there is a complete setup, run the localizer
            catch ME
                % DS.localiz.historyToWorkspace();
                rethrow(ME);
            end
            
            end
            close(gcf);
        end
        
       
        function [hFig, hp, ha] = figureSetup(DS)
        %FIGURESETUP a function used to setup a figure for testing purposes
            hFig = figure();
            subplot(2,2,1);            
            hp(1) = plot(DS.F_AXIS,zeros(1,DS.c.WINDOW_SIZE/2+1));
            ha(1) = gca;
            set(ha(1),'YLimMode','manual');
            set(ha(1),'YLim',[0 1],'XLim',[0 20E3]);
            set(ha(1),'Xscale','log');
            title('Microphone 1');
            subplot(2,2,2);            
            hp(2) = plot(DS.F_AXIS,zeros(1,DS.c.WINDOW_SIZE/2+1));
            ha(2) = gca;
            set(ha(2),'YLimMode','manual');
            set(ha(2),'YLim',[0 1],'XLim',[0 20E3]);
            set(ha(2),'Xscale','log');
            title('Microphone 2');
            subplot(2,2,3);            
            hp(3) = plot(DS.F_AXIS,zeros(1,DS.c.WINDOW_SIZE/2+1));
            ha(3) = gca;
            set(ha(3),'YLimMode','manual');
            set(ha(3),'YLim',[0 1],'XLim',[0 20E3]);
            set(ha(3),'Xscale','log');
            title('Microphone 3');
            subplot(2,2,4);            
            hp(4) = plot(DS.F_AXIS,zeros(1,DS.c.WINDOW_SIZE/2+1));
            ha(4) = gca;
            set(ha(4),'YLimMode','manual');
            set(ha(4),'YLim',[0 1],'XLim',[0 20E3]);
            set(ha(4),'Xscale','log');
            title('Microphone 4');
            
            saveButton = uicontrol('Style','pushbutton','String','Save',...
                'Position',[10,5,50,20],'Callback', @saveAudio_Callback);
            closeButton = uicontrol('Style','pushbutton','String','Close',...
                'Position',[500,5,50,20],'Callback', @closeWindow_Callback);
            function saveAudio_Callback(hObject, eventdata)
                [FileName,PathName] = uiputfile('.wav','Save Audio');
                bufferSize = length(DS.recorders(1).getBuffer());
                fileData = zeros(4,bufferSize);
                fileNames = cell(4,1);
                fileNameLength = length(FileName);
                fileExtension = FileName(fileNameLength - 3 : fileNameLength);
                trueFileName = FileName(1:fileNameLength - 4);
                for i = 1:DS.c.NUM_CHANNELS
                    fileData(i,:) = DS.recorders(i).getBuffer();
                    fileNames(i) = cellstr([PathName trueFileName '_' num2str(i) fileExtension]);
                    audiowrite(char(fileNames(i)),fileData(i,:),44100);
                end
                
                
            end
            function closeWindow_Callback(hObject, eventdata)
                DS.shutdown = 1;
                
            end
            % text boxes for displaying the output of each detector
            % (and information relevant to testing)
            %for i = 1:DS.c.NUM_CHANNELS
            %    hTextBox(i) = uicontrol('style','text');
            %    set(hTextBox(i),'String',decisions(i));
            %    set(hTextBox(i),'Position',[0 30*i 300 25])
            %end
            
            % localizer image
            %figure
            %hIm = imshow(zeros(501,501,3));
        end
        
    end
    
end