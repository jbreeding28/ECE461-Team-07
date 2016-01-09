%% fingerprint feature extraction
% The purpose of this file is to justify using an audio fingerprinting
% method for detecting drones.

% This file will read in audio saved to the computer, then generate a
% contact sheet with peaks plotted on it.

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
%% INITIAL
clear;

%% CONSTANTS
NUM_CHANNELS = 2;
FRAME_SIZE = 1024;
WINDOW_SIZE = 4096;
SLICE_NUMBER = 2;
SAMPLE_FREQUENCY_HZ = 44100;
SPECTROGRAM_OVERLAP = WINDOW_SIZE/2;
BACKGROUND_CALIBRATION_TIME = 3;
F_AXIS = linspace(0,SAMPLE_FREQUENCY_HZ/2,WINDOW_SIZE/2+1);
% number of samples to feed into the 
SAMPLES_FED = 2*WINDOW_SIZE;

%% BRING IN AUDIO

% har = dsp.AudioRecorder('NumChannels',NUM_CHANNELS,'SamplesPerFrame',FRAME_SIZE);
% hmfw = dsp.AudioFileWriter('fingerprintAudio.wav','FileFormat','WAV');
% disp('Speak into microphone now');
% tic;
% while toc < 2
%     singleFrame = step(har);
%     step(hmfw, step(har));
% end

%filename = 'Sample Audio/people-talking.wav';
filename = 'Phantom 3 (#2).wav';
%filename = 'background.wav';

[audio, Fs] = audioread(filename);
audio = audio(1:floor(2*Fs));

hFig = figure();
startTime = 0;
%% Generate contact sheet
for i = 1:16
    audioToProcess = audio(1:SAMPLES_FED);
    audio = audio((SPECTROGRAM_OVERLAP+1):length(audio));
    subplot(4,4,i)
    [pks, locs] = fingerprintProcessing(audioToProcess);
    [detected, noiseySpectrum] = hardProcessPeaks(pks, locs);
    plot(F_AXIS(locs),pks+0.02,'k^','markerfacecolor',[1 0 0]), hold off
    title([num2str(startTime), ' - ', ...
        num2str(startTime+WINDOW_SIZE/SAMPLE_FREQUENCY_HZ), ...
        's, Detected:', num2str(detected), ', Noisey spectrum:', ...
        num2str(noiseySpectrum)]);
    startTime = startTime + SPECTROGRAM_OVERLAP/SAMPLE_FREQUENCY_HZ;
end

%% NOTES
% I immediately notice that the spectrogram looks a loooot uglier than
% what's shown by a single spectrum