% LIVE SPECTROGRAM TEST ENVIRONMENT

%% CONSTANTS
FRAME_SIZE = 2048;
NUM_CHANNELS = 1;
SAMPLE_RATE_HZ = 44100;
TIME_TO_SAVE = 1;
WINDOW_SIZE = 4096;

RUN_DURATION = 10;

% FRAMES_HELD is the number of frames held per channel
FRAMES_HELD = ceil(TIME_TO_SAVE*SAMPLE_RATE_HZ/FRAME_SIZE);

%% FIGURE PREP
figure;
% setup a spectrogram plot
subplot(2,1,1)
%hSurf1 = surf(linspace(0,1,FRAMES_HELD),linspace(0,1,WINDOW_SIZE/2+1),zeros(WINDOW_SIZE/2+1,FRAMES_HELD), 'EdgeColor', 'none');
hSurf1 = surf(zeros(WINDOW_SIZE/2+1,FRAMES_HELD), 'EdgeColor', 'none');
set(hSurf1,'XData',linspace(0,(FRAMES_HELD-1)*FRAME_SIZE/SAMPLE_RATE_HZ,FRAMES_HELD));
set(hSurf1,'YData',linspace(0,SAMPLE_RATE_HZ/2,WINDOW_SIZE/2+1));

title('Smoothed spectrogram');
hAxis1 = gca;
view(0,90);
set(hAxis1, 'YScale', 'log');
xlabel('Time (s)')
ylabel('Frequency (Hz)')
%hAxis.YScale = 'log';
caxis auto

% plot the current spectrum
subplot(2,1,1)


%% Audio setup
har = dsp.AudioRecorder('NumChannels',NUM_CHANNELS,...
    'SamplesPerFrame',FRAME_SIZE,'SampleRate',SAMPLE_RATE_HZ);
har.ChannelMappingSource = 'Property';
disp('Begin testing');

%% Main loop

timeseriesBuffer = zeros(FRAMES_HELD*FRAME_SIZE,NUM_CHANNELS);
chanNumber = 1;
tic;
while toc < RUN_DURATION
    singleAudioFrame = step(har);
    curFrame = singleAudioFrame(:,chanNumber);
    % load the current frame into timeseriesBuffer and push the last frame
    % out (each column holds NUM_FRAMES_HELD frames)
    timeseriesBuffer(:,chanNumber) = [curFrame; ...
        timeseriesBuffer(1:((FRAMES_HELD-1)*FRAME_SIZE),chanNumber)];
    
    S = spectrogram(timeseriesBuffer(:,chanNumber),WINDOW_SIZE,FRAME_SIZE);
    Sdb = 10*log10(S);
    set(hSurf1,'ZData',abs(Sdb));
    drawnow;
end

release(har);
disp('Recording complete');