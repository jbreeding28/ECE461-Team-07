clear
% a script for testing the detector

% load the configuration file
load('configSettings_LaptopSetup4Channel.mat')

% create an instance of the system, and store it in a variable called
% 'system1'
ourSystem = DroneSystem(configSettings_alternate);
c = configSettings_alternate.constants;

% load test audio in
[audio1, Fs] = audioread('from2to3_01.wav');
[audio2, Fs] = audioread('from2to3_02.wav');
[audio3, Fs] = audioread('from2to3_03.wav');
[audio4, Fs] = audioread('from2to3_04.wav');

audio1 = rotorPass(audio1,Fs);
audio2 = rotorPass(audio2,Fs);
audio3 = rotorPass(audio3,Fs);
audio4 = rotorPass(audio4,Fs);

% the audio is in one long vector, and we want it to be broken into frames
% that we can put into the system one-by-one. The frameSegment() function
% splits the audio up into a big matrix, where each column is a single
% frame.
audioFrameMatrix1 = frameSegment(audio1, configSettings_alternate.constants.FRAME_SIZE);
audioFrameMatrix2 = frameSegment(audio2, configSettings_alternate.constants.FRAME_SIZE);
audioFrameMatrix3 = frameSegment(audio3, configSettings_alternate.constants.FRAME_SIZE);
audioFrameMatrix4 = frameSegment(audio4, configSettings_alternate.constants.FRAME_SIZE);

% now, load a frame into the system using the test() method. Each of
% the columns of 'audioFrameMatrix' is a single frame of audio, so we can
% access a single frame like this: x=audioFrameMatrix(:,3). This makes x
% the 3rd column of 'audioFrameMatrix'.
for i = 1:size(audioFrameMatrix1,2)
ourSystem.localizerTest([audioFrameMatrix1(:,i),audioFrameMatrix2(:,i),audioFrameMatrix3(:,i),audioFrameMatrix4(:,i)]);
end

% the outputs are the outputs for frame 1. To get the outputs for a bunch
% of frames, stick this is a loop. See Test_detectorNotRT.m for more
% advanced code.