FRAME_SIZE = 2048;

% weak signal tests
filename = 'Sample Audio/people-talking.wav';
[audio, Fs] = audioread(filename);

d1 = detector();

% 