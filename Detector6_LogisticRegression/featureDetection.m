classdef featureDetection < handle
    %DETECTOR A detector object
    
    properties (SetAccess = private)
        % c should be a struct that holds essential constants for detector
        c;
        audioRecorder;
        bufferedAudio;
        F_AXIS;
        % FRAMES_HELD is the number of frames held per channel
        FRAMES_HELD;
        previousSpectrum;
        spectrumCentroid;
        dominantFrequency;
        dominantFrequencyValue;
    end
    
    methods
         
        function D = featureDetection(configSettings,kNNStruct)
            if(nargin>0)
                D.c = configSettings.constants;
                D.F_AXIS = linspace(0,D.c.Fs/2,D.c.WINDOW_SIZE/2+1);
                D.FRAMES_HELD = ceil(D.c.TIME_TO_SAVE*D.c.Fs/D.c.FRAME_SIZE);
                D.bufferedAudio = zeros(D.FRAMES_HELD*D.c.FRAME_SIZE,1);
                D.previousSpectrum = zeros(D.c.WINDOW_SIZE/2+1,1);
                D.spectrumCentroid = 0;
            end
        end
        
        function step(D,singleAudioFrame)
        %STEP this function spits out a decision
        %   This method will be take audio one frame at a time and build up
        %   a colection of frames in the 'bufferedAudio' vector. It uses
        %   the data in the 'bufferedAudio' vector to make decisions on
        %   what kind of signal is in the audio. This is the primary method
        %   of the Detector class, and the only one that should be called
        %   publicly.
        
            % step the buffer
            D.bufferedAudio = [singleAudioFrame; ...
                D.bufferedAudio(1:((D.FRAMES_HELD-1)*D.c.FRAME_SIZE))];
            
            % spectrogram on the buffered audio, then return the relevant
            % spectrum (one slice of the spectrogram)
            spectrum = D.spectro();
            
            % feature calculation
            D.previousSpectrum = spectrum;
            [D.spectrumCentroid centroidValue] = GetSpectrumCentroid(D.bufferedAudio)
            [D.dominantFrequency D.dominantFrequencyValue] = ...
                GetDominantFrequency(D.bufferedAudio);
            
            
        end
        
        function lastSpectrum = getPreviousSpectrum(D)
           lastSpectrum = D.previousSpectrum; 
        end
        
        function features = getFeatures(D)
            features = vertcat(D.dominantFrequency,...
                D.dominantFrequencyValue, D.spectrumCentroid);
        end
        
        function spectrum = spectro(D)
        %SPECTRO calculates the spectrogram, smooths, then extracts a slice
        
            S = spectrogram(D.bufferedAudio,D.c.WINDOW_SIZE, ...
                D.c.SPECTROGRAM_OVERLAP);
            
            % apply a smoothing filter in time
            S_smooth = filter2(1/D.c.TIME_SMOOTHING_LENGTH* ...
                ones(1,D.c.TIME_SMOOTHING_LENGTH),abs(S));
            
            % extract a slice of the spectrogram
            spectrum = S_smooth(:,D.c.SLICE_NUMBER);
        end
        
    end
    
end

