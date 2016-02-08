% consider making the confidence score a function of the distance between
% "target" peaks and where the peaks actually show up

% have elliott implement max function [val idx] = max(a);


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
% k is number of peaks to find
    n = 100;
    maxval = zeros(n,1);
    ind = zeros(n,1);
    confidenceScore = 0;
    tic
    for k = 1:n
        [maxk, indk] = max(conditionedSpectrogram);
        maxval(k) = maxk; 
        ind(k) = indk;
        conditionedSpectrogram(ind(k)) = -Inf;
    end
    display(maxval);
    display(ind);
    toc
    if((conditionedSpectrogram(400-1)+conditionedSpectrogram(400)+conditionedSpectrogram(400+1))/3 >= 5)
        confidenceScore = confidenceScore + 30;
    elseif((conditionedSpectrogram(700-1)+conditionedSpectrogram(700)+conditionedSpectrogram(700+1))/3 >= 5)
        confidenceScore = confidenceScore + 30;
    elseif((conditionedSpectrogram(900-1)+conditionedSpectrogram(900)+conditionedSpectrogram(900+1))/3 >= 5)
        confidenceScore = confidenceScore + 30;
    else(confidenceScore >= 60)
            detected = 1;
            disp('Drone detected');
    end   
end


