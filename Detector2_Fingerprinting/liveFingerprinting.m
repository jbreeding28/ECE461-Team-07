NUM_CHANNELS = 2;
FRAME_SIZE = 2048;
WINDOW_SIZE = 4096;
SLICE_NUMBER = 2;
SAMPLE_FREQUENCY_HZ = 44100;
SPECTROGRAM_OVERLAP = WINDOW_SIZE/2;
F_AXIS = linspace(0,SAMPLE_FREQUENCY_HZ/2,WINDOW_SIZE/2+1);
MEAN_REMOVAL_LENGTH = 7;
PEAK_THRESHOLD = 0.2;

%% Hardware setup
har = dsp.AudioRecorder('NumChannels',NUM_CHANNELS,'SamplesPerFrame',...
    FRAME_SIZE);
disp('Speak into microphone now');

%% Variable preallocation
audioBuffer = zeros(2*WINDOW_SIZE,NUM_CHANNELS);

%% Main loop

tic;
while toc < 4
    audioBuffer = [step(audioRecorder); ...
    audioBuffer(1:(size(audioBuffer,1)-FRAME_SIZE),:)];
    
    
    
end
