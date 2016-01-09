%% Noise analysis
% the purpose of this file is to examine the features that should be
% extracted from a spectrum in order to accurately detect drones

%% contact sheet generation
% examine spectral content over time by displaying several slices of a
% spectrogram
WINDOW_SIZE = 4096;

filename = 'Sample Audio/people-talking.wav';
filename = 'Phantom 3 (#2).wav';
%filename = 'background.wav';

[audio, Fs] = audioread(filename);
audio = audio(1:floor(1.4*Fs));

contactSheet(audio, WINDOW_SIZE, WINDOW_SIZE/2, Fs, 0);
contactSheet(audio, WINDOW_SIZE, WINDOW_SIZE/2, Fs, 1);

%% Brief conclusions
% running this with 'people-talking.wav' shows that speech can be pretty
% tonal