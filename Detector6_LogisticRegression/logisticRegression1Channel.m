clear
disp('Initializing system for use with 1 mic ASIO audio input')
load('configSettings_LaptopSetup.mat')
load('kNNConfig.mat')
b = NewDroneSystem1Channel(configSettings_alternate,kNNStuff);
b.start();