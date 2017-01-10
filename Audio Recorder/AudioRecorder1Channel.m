classdef AudioRecorder1Channel
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
        recorders = AudioHolder();
        localiz;
        audioRecorder;
        F_AXIS;
        data;
        shutdown;
    end
    
    methods
        function DS = AudioRecorder1Channel(configSettings,kNNStuff)
            DS.c = configSettings.constants;
            DS.shutdown = 0;
            % DS.localiz = localizer;
            DS.c.NUM_CHANNELS = 1;
            % initialize one detector for each channel
            for i = 1:DS.c.NUM_CHANNELS
                DS.recorders(i) = AudioHolder(configSettings,kNNStuff);
            end
            
            %DS.audioRecorder = dsp.AudioRecorder('SamplesPerFrame', ...
            %    DS.c.FRAME_SIZE,'SampleRate',DS.c.Fs,'DeviceName', ...
            %    configSettings.audioDriver,'NumChannels', ...
            %    DS.c.NUM_CHANNELS);
            DS.audioRecorder = dsp.AudioRecorder('SamplesPerFrame', ...
                DS.c.FRAME_SIZE,'SampleRate',DS.c.Fs,'NumChannels', ...
                DS.c.NUM_CHANNELS);
            
            
            DS.F_AXIS = linspace(0,DS.c.Fs/2,DS.c.WINDOW_SIZE/2+1);
        end
        
        % consider trying to make an event called stop
        
        function start(DS)
            % setup the live plots
            %decisions = {'1'; '2'; '3'; '4'};
            
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
                set(hp,'XData',DS.F_AXIS,'YData',...
                   DS.recorders(1).getPreviousSpectrum());
                drawnow;
                
                % if there is a complete setup, run the localizer
            catch ME
                % DS.localiz.historyToWorkspace();
                rethrow(ME);
            end
            
            end
        end
        

        
       
        function [hFig, hp, ha] = figureSetup(DS)
        %FIGURESETUP a function used to setup a figure for testing purposes
            hFig = figure();            
            hp = plot(DS.F_AXIS,zeros(1,DS.c.WINDOW_SIZE/2+1));
            ha = gca;
            set(ha,'YLimMode','manual')
            set(ha,'YLim',[0 40],'XLim',[0 20E3])
            set(ha,'Xscale','log')
            title('Current spectrum')
            saveButton = uicontrol('Style','pushbutton','String','Save',...
                'Position',[10,5,50,20],'Callback', @saveAudio_Callback);
            closeButton = uicontrol('Style','pushbutton','String','Close',...
                'Position',[500,5,50,20],'Callback', @closeWindow_Callback);
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
            function saveAudio_Callback(hObject, eventdata)
                i = 1;
                fileData = DS.recorders(1).getBuffer();
                [FileName,PathName] = uiputfile('.wav','Save Audio');
                audiowrite([PathName FileName],fileData,44100);
            end
            function closeWindow_Callback(hObject, eventdata)
                DS.shutdown = 1;
                close(gcf);
            end
        end
        
        
    end
    
end