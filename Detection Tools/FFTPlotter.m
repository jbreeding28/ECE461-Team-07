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
        
        function features = plotContact8_spec(filename)
            %this function simulates what happens inside the detector in
            %our system as well as calculating some other features
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
                
                % feature calculation
                [HR(i), f0(i)] = feature_harmonic(...
                    audioBuffer(1:WINDOW_SIZE),Fs);
                SF(i) = spectralFlux(spectrum,lastSpectrum);
                ZCR(i) = feature_zcr(audioBuffer(1:WINDOW_SIZE));
                
                info{i} = ['HR: ',num2str(HR(i)),' f0: ',num2str(f0(i))...
                    ,' SF: ',num2str(SF(i)),' zcr: ', num2str(ZCR(i)),...
                    ' E: ', num2str(sum(spectrum.^2))];
                title([filename,' ',info{i}]);
                audioBuffer = [audioFrameMatrix(:,i);...
                    audioBuffer(1:((8-1)*WINDOW_SIZE))];
                lastSpectrum = spectrum;
            end
            features = table(f0',HR',SF',ZCR');
        end
        
        function features = plotContact8_kNN(filename)
            %this function simulates what happens inside the detector in
            %our system as well as calculating some other features
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
                
                % feature calculation
                [lag, HR(i)] = FeatureCalculator.harmonicity(...
                    audioBuffer(1:WINDOW_SIZE),40);
                f0(i) = Fs/lag;
                SF(i) = FeatureCalculator.spectralFlux(spectrum,...
                    lastSpectrum);
                ZCR(i) = feature_zcr(audioBuffer(1:WINDOW_SIZE));
                
                info{i} = ['HR: ',num2str(HR(i)),' f0: ',num2str(f0(i))...
                    ,' SF: ',num2str(SF(i)),' zcr: ', num2str(ZCR(i)),...
                    ' E: ', num2str(sum(spectrum.^2))];
                title([filename,' ',info{i}]);
                audioBuffer = [audioFrameMatrix(:,i);...
                    audioBuffer(1:((8-1)*WINDOW_SIZE))];
                lastSpectrum = spectrum;
            end
            % features = table(f0',HR',SF',ZCR');
            features = [(f0(2:8))',(SF(2:8))'];
        end
        
        function features = fullLengthFeatureGen(filename)
            WINDOW_SIZE = 4096;
            [audio,Fs] = audioread(filename);
            
            % high pass the audio
            audio = loStop(audio,Fs);
            % fill the buffer with the first 8 frames
            audioBuffer = audio(1:(8*WINDOW_SIZE));
            audio = audio((8*WINDOW_SIZE+1):length(audio));
            % segment the audio for easier access
            audioFrameMatrix = frameSegment(audio,WINDOW_SIZE);
            lastSpectrum = zeros(WINDOW_SIZE/2+1,1);
            for i = 1:size(audioFrameMatrix,2)
                
                % generate a spectrogram
                S = spectrogram(audioBuffer,WINDOW_SIZE);
                % run the spectrogram through a mean filter
                S = filter2(1/8*ones(1,8),abs(S));
                spectrum = abs(S(:,1));
                
                % feature calculation
                [HR(i), f0(i)] = feature_harmonic(...
                    audioBuffer(1:WINDOW_SIZE),Fs);
                SF(i) = spectralFlux(spectrum,lastSpectrum);
                ZCR(i) = feature_zcr(audioBuffer(1:WINDOW_SIZE));
                
                % step the buffer
                audioBuffer = [audioFrameMatrix(:,i);...
                    audioBuffer(1:((8-1)*WINDOW_SIZE))];
                lastSpectrum = spectrum;
            end
            features = table(f0',HR',SF',ZCR');
            % cut off the first row of the table, because the spectral flux
            % in the first row will make no sense (because lastSpectrum is
            % initialized to all zeros
            features = features(2:size(features,1),:);
        end
        
        function playAudio(filename)
            [audio, Fs] = audioread(filename);
            audio = loStop(audio,Fs);
            sound(audio,Fs);
        end
        
        function autoCor = timeDomainAutoCorrelation(filename)
            [audio,Fs] = audioread(filename);
            autoCor = xcorr(audio);
            autoCor = autoCor(floor(length(autoCor)/2+1):length(autoCor));
            tlag = linspace(0,length(autoCor)/Fs,length(autoCor));
            plot(tlag,autoCor);
        end
        
        function psd(filename)
            WINDOW_SIZE = 4096;
            [audio,Fs] = audioread(filename);
            audioFrameMatrix = frameSegment(audio,WINDOW_SIZE);
            pwelch(audioFrameMatrix);
        end
        
        function fftOverlay(filename,option)
            WINDOW_SIZE = 4096;
            [audio,Fs] = audioread(filename);
            audioFrameMatrix = frameSegment(audio,WINDOW_SIZE);
            ft = abs(fft(audioFrameMatrix,[],1));
            ft = ft(1:WINDOW_SIZE/2,:);
            if(nargin>1)
                while(size(ft,2)>10)
                    figure;
                    plot(linspace(0,22050,2048),ft(:,1:10));
                    ft = ft(:,11:size(ft,2));
                    set(gca,'XScale','linear','Xlim',[100 20000]);
                end
            else
                plot(linspace(0,22050,2048),ft);
            end
            
        end
    end
    
end

% audio = audio(1:4096);
%audio = cos(2*pi*1000*linspace(0,1,44100));
