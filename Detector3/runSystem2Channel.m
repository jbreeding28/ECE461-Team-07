clear
disp('Initializing system for use with 2 mic ASIO audio input')
load('configSettings_alternate.mat')
b = DroneSystem(configSettings_alternate);
b.start();