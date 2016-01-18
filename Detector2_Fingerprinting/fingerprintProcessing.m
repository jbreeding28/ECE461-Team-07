%% fingerprint feature extraction
% The purpose of this file is to justify using an audio fingerprinting
% method for detecting drones.

% In theory, the fingerprinting system here will take an audio signal as
% the input, and output amplitude and frequency information regarding
% slowly varying peaks in frequency. If this testing shows that the
% fingerprint of drones is consistantly distinct from the fingerprint of
% similar sounding noise sources (e.g. a fan), then the we should continue
% down this path.  Otherwise, a new method of information extraction should
% be devised.

% Test this file with several noise sources.  A few potential options:
% lawnmower, fan, music, cars. Highly non-stationary signals (such as
% speech) can wait until later.
function [pks, locs] = fingerprintProcessing(audioData)
%FINGERPRINTPROCESSING generates peak locations for some audio data
    
    %% CONSTANTS
    WINDOW_SIZE = 4096;
    SLICE_NUMBER = 2;
    SAMPLE_FREQUENCY_HZ = 44100;
    SPECTROGRAM_OVERLAP = WINDOW_SIZE/2;
    F_AXIS = linspace(0,SAMPLE_FREQUENCY_HZ/2,WINDOW_SIZE/2+1);
    MEAN_REMOVAL_LENGTH = 7;
    PEAK_THRESHOLD = 0.2;


    %% GENERATE SPECTROGRAM
    S = spectrogram(audioData,WINDOW_SIZE,SPECTROGRAM_OVERLAP);

    %% SMOOTH SPECTROGRAM
    %S_smooth = smoothSpectrogram(S);
    S_smooth = filter2(1/15*ones(1,15),abs(S));
    %S_smooth = abs(S);

    %% EXTRACT SIGNLE SPECTRUM
    spectrum = S_smooth(:,SLICE_NUMBER);

    %% SPECTRUM CONDITIONING
    conditionedSpectrum = meanRemovalFilter1(spectrum, MEAN_REMOVAL_LENGTH);
    conditionedSpectrum(conditionedSpectrum<0) = 0;
    plot(F_AXIS,conditionedSpectrum);
    %plot(F_AXIS, angle(S(:,SLICE_NUMBER)));
    set(gca, 'XScale', 'log'), hold on;

    %% SPECTRUM SEGMENTATION
    % 

    %% EXTRACT PEAK INFO
    % take a look at dsp.PeakFinder
    [pks, locs] = findpeaks(conditionedSpectrum, 'MINPEAKHEIGHT', PEAK_THRESHOLD);
    
    
end

%% NOTES
% I immediately notice that the spectrogram looks a loooot uglier than
% what's shown by a single spectrum