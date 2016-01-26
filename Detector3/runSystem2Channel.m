clear
disp('Initializing system for use with 2 mic ASIO audio input')
load('C:\Users\owencb\Documents\ECE46x\ECE461-Team-07\Detector3\configSettings_alternate.mat')
b = DroneSystem(configSettings_alternate);
b.start();