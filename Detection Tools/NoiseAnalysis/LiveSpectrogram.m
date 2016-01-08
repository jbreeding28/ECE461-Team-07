% LIVE SPECTROGRAM TEST ENVIRONMENT

% CONSTANTS
FRAME_SIZE = 1024;
NUM_CHANNELS = 1;
SAMPLE_RATE_HZ = 44100;
NUM_FRAMES_HELD = 4;
WINDOW_SIZE = NUM_FRAMES_HELD*FRAME_SIZE;
TIME_TO_SAVE = 3;
SAMPLES_TO_SAVE = SAMPLE_RATE_HZ*TIME_TO_SAVE;



har = dsp.AudioRecorder('NumChannels',NUM_CHANNELS,...
    'SamplesPerFrame',FRAME_SIZE,'SampleRate',SAMPLE_RATE_HZ);
har.ChannelMappingSource = 'Property';
disp('Begin testing');

% used to store a single channel's data for live spectrogram
timeseriesData = zeros(SAMPLES_TO_SAVE,1);

loopCounter = 0;
timeseriesBuffer = zeros(WINDOW_SIZE,NUM_CHANNELS);
chanNumber = 1;
tic;
while toc < 10
    singleAudioFrame = step(har);
    curFrame = singleAudioFrame(:,chanNumber);
    % load the current frame into timeseriesBuffer and push the last frame
    % out (each column holds NUM_FRAMES_HELD frames)
    timeseriesBuffer(:,chanNumber) = [curFrame; ...
        timeseriesBuffer(1:((NUM_FRAMES_HELD-1)*FRAME_SIZE),chanNumber)];
    
    % LIVE PLOTS
    % for better figure handling techniques see:
    % http://stackoverflow.com/questions/6681063/programming-in-matlab-how-to-process-in-real-time
    if(mod(loopCounter,2)==0)
        spectrogram(timeseriesBuffer(:,chanNumber));
        axis([0 0.2 0 550])
        drawnow;
    end
    loopCounter = loopCounter+1;
end

release(har);
release(hmfw);
disp('Recording complete');