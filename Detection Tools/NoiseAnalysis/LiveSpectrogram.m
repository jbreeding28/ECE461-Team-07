% LIVE SPECTROGRAM TEST ENVIRONMENT

%% CONSTANTS
FRAME_SIZE = 2048;
NUM_CHANNELS = 4;
SAMPLE_RATE_HZ = 44100;
TIME_TO_SAVE = 1;
WINDOW_SIZE = 4096;

% FRAMES_HELD is the number of frames held per channel
FRAMES_HELD = ceil(TIME_TO_SAVE*SAMPLE_RATE_HZ/FRAME_SIZE);

RUN_DURATION = 240;
F_AXIS = linspace(0,SAMPLE_RATE_HZ/2,WINDOW_SIZE/2+1);
T_AXIS = linspace(0,(FRAMES_HELD-1)*FRAME_SIZE/SAMPLE_RATE_HZ,FRAMES_HELD-1);



%% FIGURE PREP
figure;
% setup a spectrogram plot
subplot(2,1,1)
%hSurf1 = surf(linspace(0,1,FRAMES_HELD),linspace(0,1,WINDOW_SIZE/2+1),zeros(WINDOW_SIZE/2+1,FRAMES_HELD), 'EdgeColor', 'none');
hSurf1 = surf(zeros(WINDOW_SIZE/2+1,FRAMES_HELD), 'EdgeColor', 'none');
set(hSurf1,'XData',T_AXIS);
set(hSurf1,'YData',F_AXIS);

title('Smoothed spectrogram');
hAxis1 = gca;
view(0,90);
set(hAxis1, 'YScale', 'log');
xlabel('Time (s)')
ylabel('Frequency (Hz)')
%hAxis.YScale = 'log';
caxis auto

% plot the current spectrum
subplot(2,1,2)
hPlot1 = plot(F_AXIS,zeros(WINDOW_SIZE/2+1,1));
hAxis2 = gca;
set(hAxis2,'XScale','log');
set(hAxis2,'YLimMode','manual','YLim',[0,10]);
set(hAxis2,'XLim', [100, 12000])
ylabel('Frequency (Hz)')

%% Audio setup
har = dsp.AudioRecorder('NumChannels',NUM_CHANNELS,...
    'SamplesPerFrame',FRAME_SIZE,'SampleRate',SAMPLE_RATE_HZ);
%har.ChannelMappingSource = 'Property';
disp('Begin testing');

%% Main loop

timeseriesBuffer = zeros(FRAMES_HELD*FRAME_SIZE,NUM_CHANNELS);
chanNumber = 1;
tic;
while toc < RUN_DURATION
    singleAudioFrame = step(har);
    curFrame = singleAudioFrame;
    % do filter design (cont.) --> a, b coeffs
    [b,a] = butter(5,1/85,'high');
    % use filter(b,a,curFrame)
    filteredExtract = filter(b,a,curFrame);
    curFramefft = fft(filteredExtract,44100);
    m = max(curFramefft);
    M = abs(m);
    Direction(M(1),M(2),M(3),M(4));
    % load the current frame into timeseriesBuffer and push the last frame
    % out (each column holds NUM_FRAMES_HELD frames)
    timeseriesBuffer(:,:) = [curFrame; ...
        timeseriesBuffer(1:((FRAMES_HELD-1)*FRAME_SIZE),:)];
    
    S = spectrogram(timeseriesBuffer(:,chanNumber),WINDOW_SIZE,FRAME_SIZE);
    Sdb = 10*log10(S);
    set(hSurf1,'ZData',abs(Sdb));
    set(hPlot1,'YData',abs(S(:,2)))
    drawnow;
end

release(har);
disp('Recording complete');