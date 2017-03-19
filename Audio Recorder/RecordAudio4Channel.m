clear
clc
% This is the main fuction to run for recording 4 channel audio
disp('Initializing system for use with 4 mic ASIO audio input')
load('configSettings_4ChannelScarlett.mat')
load('kNNConfig.mat')
b = AudioRecorder4Channel(configSettings,kNNStuff);
b.start();