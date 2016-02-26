classdef FeatureMachine
    %FEATUREMACHINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        function features = hifreqMeanMax(filename)
            WINDOW_SIZE = 4096;
            NUM_BUCKETS = 32;
            [audio,Fs] = audioread(filename);
            audioBuffer = audio(1:(8*WINDOW_SIZE));
            audio = audio((8*WINDOW_SIZE+1):length(audio));
            % segment the audio for easier access
            audioFrameMatrix = frameSegment(audio,WINDOW_SIZE);
            
            for i = 1:size(audioFrameMatrix,2)
                
                % generate a spectrogram
                S = spectrogram(audioBuffer,WINDOW_SIZE);
                % run the spectrogram through a mean filter
                S = filter2(1/8*ones(1,8),abs(S));
                spectrum = abs(S(:,1));
                
                % feature calculation
                spectrumMatrix = frameSegment(spectrum(1025:2048),...
                    NUM_BUCKETS);
                means(i,:) = mean(spectrumMatrix,2);
                maxes(i,:) = max(spectrumMatrix,[],2);
                
                % step the buffer
                audioBuffer = [audioFrameMatrix(:,i);...
                    audioBuffer(1:((8-1)*WINDOW_SIZE))];
            end
            features = [means, maxes];
        end
    end
    
end

