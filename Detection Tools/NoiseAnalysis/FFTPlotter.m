classdef FFTPlotter
    properties
        
    end
    
    methods(Static)
        function plotStandard(filename)
            [audio, Fs] = audioread(filename);
            audio = rotorPass(audio,Fs);
            spectrum = abs(fft(audio));
            spectrum = spectrum(1:floor(length(audio)/2));
            F_AXIS = linspace(0,Fs/2,length(spectrum));
            plot(F_AXIS,spectrum)
            set(gca,'XScale','log')
        end
        
        function plotContact16(filename)
            WINDOW_SIZE = 4096;
            [audio, Fs] = audioread(filename);
            %audio = rotorPass(audio,Fs);
            audioFrameMatrix = frameSegment(audio,WINDOW_SIZE);
            for i = 1:16
                subplot(4,4,i)
                audioFrameMatrix(:,i) = rotorPass(...
                    audioFrameMatrix(:,i),Fs);
                spectrum = abs(fft(audioFrameMatrix(:,i)));
                spectrum = spectrum(1:floor(WINDOW_SIZE/2));
                F_AXIS = linspace(0,Fs/2,floor(WINDOW_SIZE/2));
                plot(F_AXIS,spectrum)
                set(gca,'XScale','log')
            end
        end
    end
    
end

% audio = audio(1:4096);
%audio = cos(2*pi*1000*linspace(0,1,44100));
