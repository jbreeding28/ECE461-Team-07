clear
disp('Initializing system for use with 4 mic ASIO (Scarlett) audio input')
load('configSettings_4ChannelScarlett.mat')
load('kNNConfig.mat')
b = DroneSystem(configSettings,kNNStuff);
b.start();