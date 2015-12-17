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

CORRELATION_THRESHOLD = 0;

F_AXIS = linspace(LOWEST_FREQ_BIN/(WINDOW_SIZE/2)*SAMPLE_RATE_HZ,...
    HIGHEST_FREQ_BIN/(WINDOW_SIZE/2)*SAMPLE_RATE_HZ, ...
    HIGHEST_FREQ_BIN-LOWEST_FREQ_BIN+1);

%% VARIABLES
load('CorrTemplates_44100Hz.mat')

audioRecorder = dsp.AudioRecorder('NumChannels',NUM_CHANNELS,...
    'SamplesPerFrame',FRAME_SIZE,'SampleRate',SAMPLE_RATE_HZ);

% preallocation for large variables
timeseriesBuffer = zeros(FRAMES_TO_HOLD*FRAME_SIZE,NUM_CHANNELS);
S = zeros(WINDOW_SIZE/2+1,15);
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
while toc < 5
    
    % save the audio data to the buffer
    timeseriesBuffer = [step(audioRecorder); ...
        timeseriesBuffer(1:(size(timeseriesBuffer,1)-FRAME_SIZE),:)];
    
    
    S = spectrogram(timeseriesBuffer(:,channelNum),...
        WINDOW_SIZE,SPEC_OVERLAP);
    S = S(LOWEST_FREQ_BIN:HIGHEST_FREQ_BIN,:);
    
    % smooth things out in frequency (averaging filter with length of 4)
    for i = 1:size(S,2)
        S_smooth(:,i) = filter2(1/4*ones(4,1), abs(S(:,i)));
    end
    
    % smooth things out in time (with a median filter)
    for i = 1:size(S,1)
        S_smooth(i,:) = medfilt1(S_smooth(i,:),16);
        %S_smooth(i,:) = filter2(1/3*ones(1,3),S_smooth(i,:));
    end
    S_smooth(S_smooth<0.095) = 0;
    % S_smooth = S_smooth-backspect;
    correlationResult = normxcorr2(template,S_smooth);
    correlationResult(correlationResult<CORRELATION_THRESHOLD) = 0;
    correlationResult(correlationResult>0) = 1;
    
    out = filter2([-0.5; 0.0; 0.5], correlationResult(:,5));
    
    for i = 1:length(out)
        
    end
    
    
end
disp('Processed finished')
