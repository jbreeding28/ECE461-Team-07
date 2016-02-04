clear
disp('Initializing system for use with 2 mic ASIO audio input')
load('configSettings_LaptopSetup.mat')
b = DroneSystem(configSettings_alternate);
b.start();