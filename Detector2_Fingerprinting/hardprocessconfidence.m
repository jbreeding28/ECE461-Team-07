% function [ detected, noisyInput ] = hardProcessPeaks( pks, locs )
% %HARDPROCESSPEAKS Hardcoded processing of peaks
% d   At this point, we can just take the peak information and try to
%    determine what we're looking at in a hardcoded manner.
%     
%     TOO_MANY_PEAKS = 10;
%     
%     detected = 0;
%     noisyInput = 0;
%     
%     if(length(pks) >= TOO_MANY_PEAKS)
%         % this does NOT work
%         warning('Powerful noise source detected');
%         noisyInput = 1;
%     else
%         % obviously, this will need to change
%         if(length(pks) >= 3)
%             detected = 1;
%             disp('Drone detected');
%             disp(locs);
%         end
%         
%     end
%     
% 
% end


function [ detected, noisyInput ] = hardProcessPeaks(conditionedSpectrogram)
%HARDPROCESSPEAKS Hardcoded processing of conditioned spectogram
%    At this point, we can just take the peak information and try to
%    determine what we're looking at in a hardcoded manner.

% Currently my thought is to average the spectrogram around the frequencies
% of 4-4.5k 19-19.5k and 17.5-18.0k. These are numbers that I achieved by
% looking at several spectrograms on audacity. Before coding these
% frequencies in I want to verify their apearance in the conditioned array
% during live testing.

% Confience score I can explain tomorrow.
    confidenceScore = 0;
    if((conditionedSpectrogram(x-1)+conditonedSpectrogram(x)+conditionspectrogram(x+1))/3 >= 5)
        confidenceScore = confidenceScore + 30;
    elseif((conditionedSpectrogram(y-1)+conditonedSpectrogram(y)+conditionspectrogram(y+1))/3 >= 5)
        confidenceScore = confidenceScore + 30;
    elseif((conditionedSpectrogram(x-1)+conditonedSpectrogram(x)+conditionspectrogram(x+1))/3 >= 5)
        confidenceScore = confidenceScore + 30;
    else(confidenceScore >= 60)
            detected = 1;
            disp('Drone detected');
    end   
end


