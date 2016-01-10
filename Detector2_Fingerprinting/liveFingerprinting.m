%% Constants
TIME_TO_SAVE = 1;

NUM_CHANNELS = 1;
FRAME_SIZE = 2048;
WINDOW_SIZE = 4096;
SLICE_NUMBER = 2;
SAMPLE_FREQUENCY_HZ = 44100;
SPECTROGRAM_OVERLAP = WINDOW_SIZE/2;
F_AXIS = linspace(0,SAMPLE_FREQUENCY_HZ/2,WINDOW_SIZE/2+1);
MEAN_REMOVAL_LENGTH = 7;
PEAK_THRESHOLD = 4;

% FRAMES_HELD is the number of frames held per channel
FRAMES_HELD = ceil(TIME_TO_SAVE*SAMPLE_FREQUENCY_HZ/FRAME_SIZE);

RUN_DURATION = 30;
T_AXIS = linspace(0,(FRAMES_HELD-1)*FRAME_SIZE/SAMPLE_FREQUENCY_HZ,FRAMES_HELD-1);

%% FIgure preperation
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

%% Hardware setup
har = dsp.AudioRecorder('NumChannels',NUM_CHANNELS,'SamplesPerFrame',...
    FRAME_SIZE);
disp('Speak into microphone now');

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

    %% GENERATE SPECTROGRAM
    S = spectrogram(timeseriesBuffer,WINDOW_SIZE,SPECTROGRAM_OVERLAP);

    %% SMOOTH SPECTROGRAM
    %S_smooth = smoothSpectrogram(S);
    S_smooth = filter2(1/15*ones(1,15),abs(S));
    %S_smooth = abs(S);

    %% EXTRACT SIGNLE SPECTRUM
    spectrum = S_smooth(:,SLICE_NUMBER);

    %% SPECTRUM CONDITIONING
    conditionedSpectrum = meanRemovalFilter1(spectrum, MEAN_REMOVAL_LENGTH);
    conditionedSpectrum(conditionedSpectrum<0) = 0;

    %% SPECTRUM SEGMENTATION
    % 

    %% EXTRACT PEAK INFO
    % take a look at dsp.PeakFinder
    [pks, locs] = findpeaks(conditionedSpectrum, 'MINPEAKHEIGHT', PEAK_THRESHOLD);
    [detected, noiseySpectrum] = hardProcessPeaks(pks, locs);
    
    Sdb = 10*log10(S);
    set(hSurf1,'ZData',abs(Sdb));
    set(hPlot1,'YData',conditionedSpectrum)
    drawnow;
end
