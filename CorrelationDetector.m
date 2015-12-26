%% Correlation Detector

%% CONSTANTS
FRAME_SIZE = 1024;
WINDOW_SIZE = 4096;
SPEC_OVERLAP = WINDOW_SIZE/2;
NUM_CHANNELS = 2;
SAMPLE_RATE_HZ = 44100;
FRAMES_TO_HOLD = 32;

CALIBRATION_DURATION = 1;

LOWEST_FREQ_BIN = 10;
HIGHEST_FREQ_BIN = 100;

CORRELATION_THRESHOLD = 0.25;

F_AXIS = linspace(LOWEST_FREQ_BIN/(WINDOW_SIZE/2)*SAMPLE_RATE_HZ,...
    HIGHEST_FREQ_BIN/(WINDOW_SIZE/2)*SAMPLE_RATE_HZ, ...
    HIGHEST_FREQ_BIN-LOWEST_FREQ_BIN+1);

%% FIGURE PREP
figure;
subplot(2,1,1)
hSurf1 = surf(zeros(91,15), 'EdgeColor', 'none');
%NEED TO PARAMETRIZE THE 91,15 THING
title('Smoothed spectrogram')
hAxis = gca;
axis([0 15 0 91 0 25 1 15])
caxis manual
subplot(2,1,2)
hSurf2 = surf(zeros(105,18),'EdgeColor','none');

%% VARIABLES
load('CorrTemplates_44100Hz.mat')

audioRecorder = dsp.AudioRecorder('NumChannels',NUM_CHANNELS,...
    'SamplesPerFrame',FRAME_SIZE,'SampleRate',SAMPLE_RATE_HZ);

% preallocation for large variables
timeseriesBuffer = zeros(FRAMES_TO_HOLD*FRAME_SIZE,NUM_CHANNELS);
current2Window = zeros(2*WINDOW_SIZE,NUM_CHANNELS);
S = zeros(HIGHEST_FREQ_BIN-LOWEST_FREQ_BIN+1,15); % FRAMES_TO_HOLD/SPEC_OVERLAP*WINDOW_SIZE
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
%     timeseriesBuffer = [step(audioRecorder); ...
%     timeseriesBuffer(1:(size(timeseriesBuffer,1)-FRAME_SIZE),:)];
% 
%     S = spectrogram(timeseriesBuffer(:,channelNum),...
%         WINDOW_SIZE,SPEC_OVERLAP);
%     S = S(LOWEST_FREQ_BIN:HIGHEST_FREQ_BIN,:);
    
 % faster processing code:
    currentFrame = step(audioRecorder);
    current2Window = [currentFrame; current2Window(1:(WINDOW_SIZE-FRAME_SIZE),:)];
    Snew = spectrogram(current2Window(:,channelNum),WINDOW_SIZE,SPEC_OVERLAP);
    Snew = Snew(LOWEST_FREQ_BIN:HIGHEST_FREQ_BIN,:);
    S = [Snew S(:,1:size(S,2)-1)];
    
    
    % smooth things out in frequency (averaging filter with length of 4)
    for i = 1:size(S,2)
        S_smooth(:,i) = filter2(1/2*ones(2,1), abs(S(:,i)));
    end
    
    % smooth things out in time (with a median filter)
    for i = 1:size(S,1)
        % the 1D median filter is slow
        %S_smooth(i,:) = medfilt1(S_smooth(i,:),8);
        S_smooth(i,:) = filter2(1/3*ones(1,3),S_smooth(i,:));
    end
    S_smooth(S_smooth<0.095) = 0;
    % S_smooth = S_smooth-backspect;
    correlationResult = normxcorr2(template,S_smooth);
    correlationResult(correlationResult<CORRELATION_THRESHOLD) = 0;
    correlationResult(correlationResult>0) = 1;
    
    
    out = filter2([-0.5; 0.0; 0.5], correlationResult(:,1));
    
    %subplot(2,1,2)
    set(hSurf1,'ZData',abs(S_smooth));
    set(hSurf2, 'ZData', correlationResult);
    drawnow;
%     for i = 1:length(out)
%         
%     end
    
    
end
disp('Processed finished')

