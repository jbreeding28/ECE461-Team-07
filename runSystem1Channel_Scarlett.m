clear
disp('Initializing system for use with 2 mic ASIO audio input')
load('configSettings.mat')
b = DroneSystem(configSettings);
b.start();