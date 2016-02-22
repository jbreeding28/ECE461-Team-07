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
            for i = 1:8
                subplot(4,2,i)
                audioFrameMatrix(:,i) = rotorPass(...
                    audioFrameMatrix(:,i),Fs);
                spectrum = abs(fft(audioFrameMatrix(:,i)));
                spectrum = spectrum(1:floor(WINDOW_SIZE/2));
                F_AXIS = linspace(0,Fs/2,floor(WINDOW_SIZE/2));
                plot(F_AXIS,spectrum)
                set(gca,'XScale','log')
                [HR, f0] = feature_harmonic(audioFrameMatrix(:,i), Fs);
                title(['HR: ',num2str(HR),' f0: ',num2str(f0)]);
            end
        end
        
        function info = plotContact8_spec(filename)
            %this function simulates what happens inside the detector in
            %our system as well as calculating some other features
            info = {filename};
            WINDOW_SIZE = 4096;
            [audio, Fs] = audioread(filename);
            audio = loStop(audio,Fs);
            audioBuffer = audio(1:(8*WINDOW_SIZE));
            audio = audio((8*WINDOW_SIZE+1):length(audio));
            audioFrameMatrix = frameSegment(audio,WINDOW_SIZE);
            lastSpectrum = zeros(WINDOW_SIZE/2+1,1);
            for i = 1:8
                subplot(4,2,i)
                S = spectrogram(audioBuffer,WINDOW_SIZE);
                S = filter2(1/8*ones(1,8),abs(S));
                spectrum = abs(S(:,1));
                F_AXIS = linspace(0,Fs/2,floor(WINDOW_SIZE/2)+1);
                plot(F_AXIS,spectrum)
                set(gca,'XScale','log','XLim',[100 Fs/2])
                %[HR, f0] = feature_harmonic(audioBuffer(:,1), Fs);
                [HR, f0] = feature_harmonic(audioBuffer(1:WINDOW_SIZE),Fs);
                info{i} = ['HR: ',num2str(HR),' f0: ',num2str(f0),' SF: ',...
                    num2str(spectralFlux(spectrum,lastSpectrum)),...
                    ' zcr: ', num2str(feature_zcr...
                    (audioBuffer(1:WINDOW_SIZE)))];
                title([filename,' ',info{i}]);
                audioBuffer = [audioFrameMatrix(:,i);...
                    audioBuffer(1:((8-1)*WINDOW_SIZE))];
                lastSpectrum = spectrum;
            end
        end
        
        function playAudio(filename)
            [audio, Fs] = audioread(filename);
            sound(audio,Fs);
        end
    end
    
end

% audio = audio(1:4096);
%audio = cos(2*pi*1000*linspace(0,1,44100));
