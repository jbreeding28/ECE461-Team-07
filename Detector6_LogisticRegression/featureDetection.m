classdef featureDetection < handle
    %featureDetection an object to hold feature data and buffered audio for
    %each microphone. One of these exists in the main code for each
    %microphone.
    
    properties (SetAccess = private)
        % c should be a struct that holds essential constants for detector
        c;
        % This matrix holds about a second's worth of audio, and is loaded
        % 2048 samples at a time.
        bufferedAudio;
        %F_AXIS;
        % a and b represent the coefficients for a Butterworth filter.
        % Low components are for the lowpass filter. High components are
        % for the highpass filter.
        aLow;
        bLow;
        aHigh;
        bHigh;
        % FRAMES_HELD is the number of frames held per channel. This is
        % used to check when features need to be updated.
        FRAMES_HELD;
        % holds the last calculated frequency spectrum. This is used so
        % that the four frequency spectrum plots update frequently. These
        % transforms contain fewer data points than the transform used for
        % feature calculation to fit on the plots.
        previousSpectrum;
        % below are features we tried out at various points in time. Not
        % all of them are used in the final code, but they remain in case
        % someone wants to use them.
        spectrumCentroid;
        domFreq1;
        domFreq2;
        domFreq3;
        domFreq4;
        domFreq5;
        domValue1;
        domValue2;
        domValue3;
        domValue4;
        domValue5;
        silence;
        spectralFlux;
        zcr;
        energy;
        % How many times the buffer has been refreshed. This needs to be
        % equal to the number of frames held to trigger ffeature update.
        bufferCount;
        % The fourier transform of the whole buffer. This is used to
        % calculate features.
        transform;
    end
    
    methods
        % The constructor generates the highpass and lowpass butterworth
        % filters and initializes the buffer length.
        function D = featureDetection(configSettings,kNNStruct)
            if(nargin>0)
                % 1 kHz was chosen as the cutoff point for the highpass
                % filter
                WnHigh = (1000 * 2)/44100;
                % 16 kHz was chosen as the cutoff point for the lowpass
                % filter
                WnLow = (16000 * 2)/44100;
                % The filter was chosen to be a third order
                n = 3;
                D.bufferCount = 0;
                % The filter coefficients are generated
                [D.bHigh D.aHigh] = butter(n,WnHigh,'high');
                [D.bLow D.aLow] = butter(n,WnLow,'low');
                D.c = configSettings.constants;
                %D.F_AXIS = linspace(0,D.c.Fs/2,D.c.WINDOW_SIZE/2+1);
                D.FRAMES_HELD = ceil(D.c.TIME_TO_SAVE*D.c.Fs/D.c.FRAME_SIZE);
                D.bufferedAudio = zeros(D.FRAMES_HELD*D.c.FRAME_SIZE,1);
                D.previousSpectrum = zeros(D.c.WINDOW_SIZE/2+1,1);
                %D.spectrumCentroid = 0;
            end
        end
        
        function featuresUpdated = step(D,singleAudioFrame)
        %STEP this function updates the audio buffer and the features when
        %necessary. When the buffer count is filled, featuresUpdated
        %returns as true, signalling to the main code to extract the
        %features.
        
            % lowpass filter the frame
            featuresUpdated = false;
            lowpassedAudioFrame = filter(D.bLow,D.aLow,singleAudioFrame);
            % highpass filter
            highpassedAudioFrame = filter(D.bHigh,D.aHigh,lowpassedAudioFrame);
            % step the buffer
            %filtering just the frames and not the buffer as a whole leads
            %to periodic "clicks" in the time domain. However, it doesn't
            %affect performance much, and is less resource intensive than
            %having to filter the buffer as a whole.
            D.bufferedAudio = [highpassedAudioFrame; ...
                D.bufferedAudio(1:((D.FRAMES_HELD-1)*D.c.FRAME_SIZE))];
            % spectrogram on the buffered audio, then return the relevant
            % spectrum (one slice of the spectrogram)
            spectrum = D.spectro();
            
            % feature calculation
            D.previousSpectrum = spectrum;
            D.bufferCount = D.bufferCount + 1;
            % calculate features only when the buffer is filled.
            if D.bufferCount == D.FRAMES_HELD
                D.transform = abs(fftshift(fft(D.bufferedAudio)));
                binsize_Hz = (D.c.Fs/2)/(D.c.WINDOW_SIZE/2+1);
                midPoint = ceil(length(D.transform)/2);
                D.transform(midPoint - ceil(150/binsize_Hz):...
                    midPoint + ceil(150/binsize_Hz) + 1) = 0;
                [D.spectrumCentroid centroidValue] = GetSpectrumCentroid(D.transform);
                [dominantFrequencyValues dominantFrequencies] = GetPeaks(D.transform);
                D.spectralFlux = GetSpectrumFlux(D.bufferedAudio);
                D.silence = GetSilencePercentage(D.bufferedAudio);
                [STE, STEavg, D.energy] = GetEnergyInfo(D.bufferedAudio);
                [STZCR, avgZCR, D.zcr] = GetZCRInfo(D.bufferedAudio);
                % we calculate the first five peaks. However, using all of
                % these led to issues when built into a database matrix.
                D.domFreq1 = dominantFrequencies(1)
                D.domFreq2 = dominantFrequencies(2);
                D.domFreq3 = dominantFrequencies(3);
                D.domFreq4 = dominantFrequencies(4);
                D.domFreq5 = dominantFrequencies(5);
                D.domValue1 = dominantFrequencyValues(1);
                D.domValue2 = dominantFrequencyValues(2);
                D.domValue3 = dominantFrequencyValues(3);
                D.domValue4 = dominantFrequencyValues(4);
                D.domValue5 = dominantFrequencyValues(5);
                D.bufferCount = 0;
                %D.silence = GetSilencePercentage(D.bufferedAudio);
                featuresUpdated = true;
            end
        end
        
        % getPreviousSpectrum returns the fourier transform for the current
        % buffer. This is called to update the frequency spectrum plots.
        function lastSpectrum = getPreviousSpectrum(D)
           lastSpectrum = D.previousSpectrum; 
        end
        
        %getFeatures returns all features, vertically concatenated into one
        %matrix. This function can be changed as necessary.
        function features = getFeatures(D)
            %features = vertcat(D.domFreq1, D.domValue1);
            % IMPORTANT
            % the features must be THE SAME features used to build the
            % model and must beconcatenated in the same order as they
            % were concatenated from the signal database EXACTLY. Different
            % features or a different order will lead to a broken detection
            % system.
            features = vertcat(D.domFreq1,D.domFreq2,...
                D.domValue1,D.domValue2,...
                D.energy,D.silence);
        end
        
        % getPwrDB returns the rms power in dB of the microphone's signal.
        % This is used in the main code for direction finding.
        function pwrDB = getPwrDB(D)
            pwrDB = mag2db(rms(D.bufferedAudio));
        end
        
        % getBufferedAudio returns the full buffer for this object
        function buffer = getBufferedAudio(D)
            buffer = D.bufferedAudio();
        end
        
        % getTransform returns the full transform used for feature
        % calculation
        function transform = getTransform(D)
            transform = D.transform();
        end
        
        % This function has changed slightly. Initially calculated a
        % spectrogram for the transform plots, but now this generates
        % fourier transforms for the plots.
        % these transforms have less data points to fit on the plots
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

