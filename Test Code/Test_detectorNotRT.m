clear
%% INFO

% CHRISTIAN: WRITE DOCUMENTATION FOR THIS

% (1) is weak signal
% 

% steps for testing using the non RT method
% specify an audio recording



%% get the system running
load('Detector3\configSettings_alternate.mat')
% c, a struct, will hold the constants
c = configSettings_alternate.constants;

%% single channel detector tests
configSettings_alternate.constants.NUM_CHANNELS = 1;
system1 = DroneSystem(configSettings_alternate);
% weak signal tests
filename = 'Sample Audio/Our Recordings/Scarlett 18i8/4 3-Audio-1, background noise.wav';
[audio, Fs] = audioread(filename);
audioFrameMatrix = frameSegment(audio,c.FRAME_SIZE);

failedDecisionIndexes = [];
correct = 1;
decisions = cell(size(audioFrameMatrix,2),1);
for i = 1:size(audioFrameMatrix,2)
    decisions(i) = {system1.test(audioFrameMatrix(:,i))};
    if(decisions{i}~=correct)
        failedDecisionIndexes = [failedDecisionIndexes; i];
    end
end
