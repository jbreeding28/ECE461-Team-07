clear
% create a DroneSystem object
load('configSettings_LaptopSetup4Channel.mat')
system1 = DroneSystem(configSettings_alternate);

% define file names
channel1 = 'from1to2_01.wav';
channel2 = 'from1to2_02.wav';
channel3 = 'from1to2_03.wav';
channel4 = 'from1to2_04.wav';

% bring in the audio data
[audio_01, Fs] = audioread(channel1);
[audio_02, Fs] = audioread(channel2);
[audio_03, Fs] = audioread(channel3);
[audio_04, Fs] = audioread(channel4);

% segment
audioFrameMatrix01 = frameSegment(audio_01,configSettings_alternate.constants.FRAME_SIZE);
audioFrameMatrix02 = frameSegment(audio_02,configSettings_alternate.constants.FRAME_SIZE);
audioFrameMatrix03 = frameSegment(audio_03,configSettings_alternate.constants.FRAME_SIZE);
audioFrameMatrix04 = frameSegment(audio_04,configSettings_alternate.constants.FRAME_SIZE);

system1.start();

system1.localizerTest(A1,A2,A3,A4);

% take the ave power for each channel and pass those to the localizerTest()
% function

