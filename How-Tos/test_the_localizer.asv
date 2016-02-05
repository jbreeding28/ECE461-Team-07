clear
% a script for testing the detector

% load the configuration file
load('configSettings_LaptopSetup.mat')

% create an instance of the system, and store it in a variable called
% 'system1'
ourSystem = DroneSystem(configSettings_alternate);
c = configSettings_alternate.constants;

% load test audio in
[audio, Fs] = audioread('4 3-Audio-1, speech.wav');

% the audio is in one long vector, and we want it to be broken into frames
% that we can put into the system one-by-one. The frameSegment() function
% splits the audio up into a big matrix, where each column is a single
% frame.
audioFrameMatrix = frameSegment(audio, configSettings_alternate.constants.FRAME_SIZE);

% now, load a frame into the system using the test() method. Each of
% the columns of 'audioFrameMatrix' is a single frame of audio, so we can
% access a single frame like this: x=audioFrameMatrix(:,3). This makes x
% the 3rd column of 'audioFrameMatrix'.
[decision,energy,flux] = ourSystem.test(audioFrameMatrix(:,1));

% the outputs are the outputs for frame 1. To get the outputs for a bunch
% of frames, stick this is a loop. See Test_detectorNotRT.m for more
% advanced code.