% this will:
% take FFT
% divide into sections
% extract features from each section
% make decisions based on those features

% I'VE NOTICED:
% Low freqs have distinct "peaks"
% High freqs have more broadband "bumps"

% CONSTANTS
WINDOW_SIZE = 1024;
NUM_CHANNELS = 2;
NUM_SPECTRUM_SLICES = 20;
SAMPLE_RATE_HZ = 44100;

har = dsp.AudioRecorder('NumChannels',NUM_CHANNELS,...
    'SamplesPerFrame',WINDOW_SIZE,'SampleRate',SAMPLE_RATE_HZ);
har.ChannelMappingSource = 'Property';
har.DeviceName = 'ASIO4ALL v2';
hmfw = dsp.AudioFileWriter('myspeech.wav','FileFormat','WAV');
disp('Speak into microphone now');

tic;
while toc < 5
    singleAudioFrame = step(har);
    for chanNum = 1:NUM_CHANNELS
        window = singleAudioFrame(:,chanNum);
        % slices = segment(abs(fft(window)), NUM_SPECTRUM_SLICES);
        % var and mean calculated along the columns
        % var(slices);
        % mean(slices);
    end
end

release(har);
release(hmfw);
disp('Recording complete');

% need to write a quick 