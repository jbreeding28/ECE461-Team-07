clear
clc
% Deprecated. A loading class for the 1 channel system, which was built
% just for testing.
disp('Initializing system for use with 1 mic ASIO audio input')
load('configSettings_4ChannelScarlett.mat')
load('kNNConfig.mat')
b = NewDroneSystem1Channel(configSettings,kNNStuff);
b.start();