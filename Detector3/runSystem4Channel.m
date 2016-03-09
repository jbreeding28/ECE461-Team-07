clear
disp('Initializing system for use with 4 mic ASIO (Scarlett) audio input')
load('configSettings_4ChannelScarlett.mat')
b = DroneSystem(configSettings);
b.start();