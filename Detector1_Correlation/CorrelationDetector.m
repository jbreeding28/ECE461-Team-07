%% Correlation Detector
% A detector that uses correlation to find peaks
%% CONSTANTS
FRAME_SIZE = 1024;
WINDOW_SIZE = 4096;
SPEC_OVERLAP = WINDOW_SIZE/2;
NUM_CHANNELS = 2;
SAMPLE_RATE_HZ = 44100;
FRAMES_TO_HOLD = 15;

CALIBRATION_DURATION = 1;

LOWEST_FREQ_BIN = 20;
HIGHEST_FREQ_BIN = 100;

CORRELATION_THRESHOLD = 0.25;

F_AXIS = linspace(LOWEST_FREQ_BIN/(WINDOW_SIZE/2)*SAMPLE_RATE_HZ,...
    HIGHEST_FREQ_BIN/(WINDOW_SIZE/2)*SAMPLE_RATE_HZ, ...
    HIGHEST_FREQ_BIN-LOWEST_FREQ_BIN+1);

%% FIGURE PREP
figure;
% setup a spectrogram plot
subplot(2,1,1)
hSurf1 = surf(zeros(HIGHEST_FREQ_BIN-LOWEST_FREQ_BIN,15), 'EdgeColor', 'none');
%NEED TO PARAMETRIZE THE 91,15 THING
title('Smoothed spectrogram')
hAxis1 = gca;
view(0,90);
set(hAxis1, 'YScale', 'log');
%hAxis.YScale = 'log';
axis([0 FRAMES_TO_HOLD 0 HIGHEST_FREQ_BIN-LOWEST_FREQ_BIN 0 25 1 15])
caxis manual
% set up a correlation plot
subplot(2,1,2)
hSurf2 = surf(zeros(105,18),'EdgeColor','none');
hAxis2 = gca;
view(0,90);
set(hAxis2, 'YScale', 'log');

%% VARIABLES
load('CorrTemplates_44100Hz.mat')

audioRecorder = dsp.AudioRecorder('NumChannels',NUM_CHANNELS,...
    'SamplesPerFrame',FRAME_SIZE,'SampleRate',SAMPLE_RATE_HZ);

% preallocation for large variables
timeseriesBuffer = zeros(FRAMES_TO_HOLD*FRAME_SIZE,NUM_CHANNELS);
current2Window = zeros(2*WINDOW_SIZE,NUM_CHANNELS);
S = zeros(HIGHEST_FREQ_BIN-LOWEST_FREQ_BIN+1,FRAMES_TO_HOLD); % FRAMES_TO_HOLD/SPEC_OVERLAP*WINDOW_SIZE
S_smooth = zeros(HIGHEST_FREQ_BIN-LOWEST_FREQ_BIN+1,size(S,2));

%% PREPROCESSING
% disp('Calibrating...')
% backspect = backgroundSpectrum(CALIBRATION_DURATION,SAMPLE_RATE_HZ,...
%     WINDOW_SIZE,SPEC_OVERLAP);
% disp('Calibrating completed')

%% PROCESSING LOOP
disp('Processing started')
channelNum = 1;
tic;
while toc < 60
    
    % save the audio data to the buffer
    timeseriesBuffer = [step(audioRecorder); ...
    timeseriesBuffer(1:(size(timeseriesBuffer,1)-FRAME_SIZE),:)];

    S = spectrogram(timeseriesBuffer(:,channelNum),...
        WINDOW_SIZE,SPEC_OVERLAP);
    S = S(LOWEST_FREQ_BIN:HIGHEST_FREQ_BIN,:);
    
 % faster processing code:
%     currentFrame = step(audioRecorder);
%     current2Window = [currentFrame; current2Window(1:(WINDOW_SIZE-FRAME_SIZE),:)];
%     Snew = spectrogram(current2Window(:,channelNum),WINDOW_SIZE,SPEC_OVERLAP);
%     Snew = Snew(LOWEST_FREQ_BIN:HIGHEST_FREQ_BIN,:);
%     S = [Snew S(:,1:size(S,2)-1)];
    
    S_smooth = smoothSpectrogram(S);
    S_smooth(S_smooth<(1.1*mean(mean(abs(S_smooth))))) = 0;
    S_smooth(S_smooth<0.4) = 0;
    % S_smooth = S_smooth-backspect;
    
    correlationResult = normxcorr2(template,S_smooth);
    correlationResult(correlationResult<CORRELATION_THRESHOLD) = 0;
    correlationResult(correlationResult>0) = 1;
    
    
    out = filter2([-0.5; 0.0; 0.5], correlationResult(:,1));
    
    %subplot(2,1,2)
    set(hSurf1,'ZData',abs(S_smooth));
    set(hSurf2, 'ZData', correlationResult);
    drawnow;
    
    
end
disp('Processed finished')

