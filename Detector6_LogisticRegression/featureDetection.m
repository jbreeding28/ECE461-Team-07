classdef featureDetection < handle
    %DETECTOR A detector object
    
    properties (SetAccess = private)
        % c should be a struct that holds essential constants for detector
        c;
        audioRecorder;
        bufferedAudio;
        F_AXIS;
        % a and b represent the coefficients for a Butterworth filter
        aLow;
        bLow;
        aHigh;
        bHigh;
        % FRAMES_HELD is the number of frames held per channel
        FRAMES_HELD;
        previousSpectrum;
        spectrumCentroid;
        dominantFrequency;
        dominantFrequencyValue;
        bufferCount;
    end
    
    methods
         
        function D = featureDetection(configSettings,kNNStruct)
            if(nargin>0)
                WnLow = (1000 * 2)/44100;
                WnHigh = (16000 * 2)/44100;
                n = 3;
                D.bufferCount = 0;
                [D.bHigh D.aHigh] = butter(n,WnLow,'high');
                [D.bLow D.aLow] = butter(n,WnHigh,'low');
                D.c = configSettings.constants;
                D.F_AXIS = linspace(0,D.c.Fs/2,D.c.WINDOW_SIZE/2+1);
                D.FRAMES_HELD = ceil(D.c.TIME_TO_SAVE*D.c.Fs/D.c.FRAME_SIZE);
                D.bufferedAudio = zeros(D.FRAMES_HELD*D.c.FRAME_SIZE,1);
                D.previousSpectrum = zeros(D.c.WINDOW_SIZE/2+1,1);
                %D.spectrumCentroid = 0;
            end
        end
        
        function featuresUpdated = step(D,singleAudioFrame)
        %STEP this function spits out a decision
        %   This method will be take audio one frame at a time and build up
        %   a colection of frames in the 'bufferedAudio' vector. It uses
        %   the data in the 'bufferedAudio' vector to make decisions on
        %   what kind of signal is in the audio. This is the primary method
        %   of the Detector class, and the only one that should be called
        %   publicly.
        
            % lowpass filter the frame
            featuresUpdated = false;
            lowpassedAudioFrame = filter(D.bLow,D.aLow,singleAudioFrame);
            highpassedAudioFrame = filter(D.bHigh,D.aHigh,lowpassedAudioFrame);
            % step the buffer
            D.bufferedAudio = [highpassedAudioFrame; ...
                D.bufferedAudio(1:((D.FRAMES_HELD-1)*D.c.FRAME_SIZE))];
            % spectrogram on the buffered audio, then return the relevant
            % spectrum (one slice of the spectrogram)
            spectrum = D.spectro();
            
            % feature calculation
            D.previousSpectrum = spectrum;
            D.bufferCount = D.bufferCount + 1;
            if D.bufferCount == D.FRAMES_HELD
                [D.spectrumCentroid centroidValue] = GetSpectrumCentroid(D.bufferedAudio);
                [D.dominantFrequencyValue D.dominantFrequency] = ...
                GetDominantFrequency(D.bufferedAudio);
                D.bufferCount = 0;
                featuresUpdated = true;
            end
            
            
            
        end
        
        function lastSpectrum = getPreviousSpectrum(D)
           lastSpectrum = D.previousSpectrum; 
        end
        
        function features = getFeatures(D)
            %features = D.dominantFrequencyValue;
            features = vertcat(D.dominantFrequency,...
                D.dominantFrequencyValue);
        end
        
        function pwrDB = getPwrDB(D)
            pwrDB = mag2db(rms(D.bufferedAudio));
        end
        
        function spectrum = spectro(D)
        %SPECTRO calculates the spectrogram, smooths, then extracts a slice
            spectrum = abs(fftshift(fft(D.bufferedAudio,4097)));
            spectrum = spectrum(ceil(length(spectrum)/2):length(spectrum));
            %S = spectrogram(D.bufferedAudio,D.c.WINDOW_SIZE, ...
            %    D.c.SPECTROGRAM_OVERLAP);
            
            % apply a smoothing filter in time
            %spectrum = filter2(1/D.c.TIME_SMOOTHING_LENGTH* ...
            %    ones(1,D.c.TIME_SMOOTHING_LENGTH),abs(S));
            
            % extract a slice of the spectrogram
            %spectrum = S_smooth(:,D.c.SLICE_NUMBER);
        end
        
    end
    
end

