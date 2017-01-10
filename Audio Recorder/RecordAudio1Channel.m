clear
disp('Initializing system for use with 1 mic ASIO audio input')
load('configSettings_4ChannelScarlett.mat')
load('kNNConfig.mat')
b = AudioRecorder1Channel(configSettings,kNNStuff);
b.start();