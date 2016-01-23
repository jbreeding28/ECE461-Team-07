classdef DroneSystem
    %DRONESYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % c holds constants
        c;
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
            outputs = {'1'; '2'; '3'; '4'};
            figure()
            % make text boxes for displaying the output of each detector
            for i = 1:DS.c.NUM_CHANNELS
                hTextBox(i) = uicontrol('style','text');
                set(hTextBox(i),'String',outputs(i));
                set(hTextBox(i),'Position',[0 30*i 100 25])
            end
            
            while(1)
                audioFrame = step(DS.audioRecorder);
                for i = 1:DS.c.NUM_CHANNELS
                    outputs(i) = {DS.detectors(i).step(audioFrame(:,i))};
                    set(hTextBox(i),'String',outputs(i));
                end
                drawnow;
                
            end
        end
        
        function calibration(DS)
            
        end
        
    end
    
end

