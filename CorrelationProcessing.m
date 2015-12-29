% post processing correlation
load('CorrTemplates_44100Hz.mat')
% CORRELATION_TEMPLATE = Templates_DJIPhantom3.singleSpike;
WINDOW_SIZE = 4096;
LOWEST_FREQ_BIN = 1;
HIGHEST_FREQ_BIN = 2049;

audioClip = audioread('Sample Audio/13 Internet_DJIPhantom3.wav');
%audioClip = audioread('Sample Audio/cheapDrone_50feet.wav');
%audioClip = audioread('Sample Audio/Phantom 3 (#2).wav');
%[audioClip,Fs] = audioread('Sample Audio/phantomTakingOff.mp3');

figure();
[S,F,T] = spectrogram(audioClip(:,1),WINDOW_SIZE,WINDOW_SIZE/2);
S = S(LOWEST_FREQ_BIN:HIGHEST_FREQ_BIN,:);
subplot(3,1,1)
%surf(FIndices,TIndicies,abs(S_db), 'EdgeColor','none')
hSurf = surf(10.*log10(abs(S)), 'EdgeColor','none');
% for somewhat looking log plots, uncomment the below code:
c = (linspace(LOWEST_FREQ_BIN,...
    HIGHEST_FREQ_BIN,HIGHEST_FREQ_BIN-LOWEST_FREQ_BIN+1)).^0.25;
set(hSurf,'YData',c)
title(['Spectrogram, window size: ', num2str(WINDOW_SIZE)])

% threshold out little signals (so we don't end up blowing up something
% insignificant)

% local normalization (divide local sections by their sum)

S_smooth = smoothSpectrogram(S);

subplot(3,1,2)
S_smooth(S_smooth<1.1*mean(mean(S_smooth))) = 0;
surf(10.*log10(S_smooth), 'EdgeColor','none')

% correlation and binary image generation
CORRELATION_THRESHOLD = 0.5;
subplot(3,1,3)
correlationResult = normxcorr2(template,S_smooth);
a = correlationResult;
correlationResult(correlationResult<CORRELATION_THRESHOLD) = 0;
correlationResult(correlationResult>0) = 1;
% correlationResult = bwulterode(correlationResult); % erosion is difficult
surf(double(correlationResult), 'EdgeColor','none')

% I need to come up with a good way to threshold
% look at more data and determine the best way to do this
% taking the local mean and subtracting by it would work for a stationary
% DJI 3


% think about correlating a 2D peak kernal with a small chunk of a
% spectrogram




