clear
%% INFO

% CHRISTIAN: WRITE DOCUMENTATION FOR THIS

% (1) is weak signal
% (2) is a highly non stationary signal
% (3) is a non-drone oscillator
% (4) is a drone oscillator

% steps for testing using the non RT method
% specify an audio recording



%% get the system running
load('Detector3\configSettings_LaptopSetup.mat')
% c, a struct, will hold the constants
c = configSettings_alternate.constants;

%% single channel detector tests
configSettings_alternate.constants.NUM_CHANNELS = 1;
system1 = DroneSystem(configSettings_alternate);
%% weak signal test(s)
testname = 'single channel weak signal test';
disp(testname)
filename = 'Sample Audio/Our Recordings/Scarlett 18i8/4 3-Audio-1, background noise.wav';
[audio, Fs] = audioread(filename);
audioFrameMatrix = frameSegment(audio,c.FRAME_SIZE);

failedDecisionIndexes = [];
correct = 1;
decisions = cell(size(audioFrameMatrix,2),1);
fluxes = zeros(1,size(audioFrameMatrix,2));
energies = zeros(1,size(audioFrameMatrix,2));
for i = 1:size(audioFrameMatrix,2)
    [decisions(i),curFlux,curEnergy] = system1.test(audioFrameMatrix(:,i));
    fluxes(i) = curFlux;
    energies(i) = curEnergy;
    if(decisions{i}~=correct)
        failedDecisionIndexes = [failedDecisionIndexes; i];
    end
end

% remove edge effects due to the smoothing filter 
energies = energies(c.TIME_SMOOTHING_LENGTH:length(energies));
fluxes = fluxes(c.TIME_SMOOTHING_LENGTH:length(fluxes));

% generate a feature space plot
figure;
plot(fluxes,energies,'o')
title(testname)
xlabel('Normalized spectral flux')
ylabel('Spectral energy')

if(~isempty(failedDecisionIndexes))
    disp(['Failed weak signal test at indicies: ', num2str(failedDecisionIndexes)]);
end
disp(['mean/max energy: ', num2str(mean(energies)),'/', num2str(max(energies))])
disp(['mean/max flux: ', num2str(mean(fluxes)),'/', num2str(max(fluxes))])
disp('--');

%% Highly non-stationary tests (footsteps)
testname = 'single channel non stationary (footsteps) test';
disp(testname)
filename = '4 3-Audio-1, footsteps.wav';
[audio, Fs] = audioread(filename);
audioFrameMatrix = frameSegment(audio,c.FRAME_SIZE);

decisions = cell(size(audioFrameMatrix,2),1);
fluxes = zeros(1,size(audioFrameMatrix,2));
energies = zeros(1,size(audioFrameMatrix,2));
for i = 1:size(audioFrameMatrix,2)
    [decisions(i),fluxes(i),energies(i)] = system1.test(audioFrameMatrix(:,i));
end

% remove edge effects due to the smoothing filter 
energies = energies(c.TIME_SMOOTHING_LENGTH:length(energies));
fluxes = fluxes(c.TIME_SMOOTHING_LENGTH:length(fluxes));

% generate a feature space plot
figure;
plot(fluxes,energies,'o')
title(testname)
xlabel('Normalized spectral flux')
ylabel('Spectral energy')

disp(['mean/max energy: ', num2str(mean(energies)),'/', num2str(max(energies))])
disp(['mean/max flux: ', num2str(mean(fluxes)),'/', num2str(max(fluxes))])
disp('--')
%% another non stationary test (simple speech)
testname = 'single channel non stationary (simple speech) test';
disp(testname)
filename = '4 3-Audio-1, speech.wav';
[audio, Fs] = audioread(filename);
audioFrameMatrix = frameSegment(audio,c.FRAME_SIZE);

decisions = cell(size(audioFrameMatrix,2),1);
fluxes = zeros(1,size(audioFrameMatrix,2));
energies = zeros(1,size(audioFrameMatrix,2));
for i = 1:size(audioFrameMatrix,2)
    [decisions(i),fluxes(i),energies(i)] = system1.test(audioFrameMatrix(:,i));
end

% remove edge effects due to the smoothing filter 
energies = energies(c.TIME_SMOOTHING_LENGTH:length(energies));
fluxes = fluxes(c.TIME_SMOOTHING_LENGTH:length(fluxes));

% generate a feature space plot
figure;
plot(fluxes,energies,'o')
title(testname)
xlabel('Normalized spectral flux')
ylabel('Spectral energy')

disp(['mean/max energy: ', num2str(mean(energies)),'/', num2str(max(energies))])
disp(['mean/max flux: ', num2str(mean(fluxes)),'/', num2str(max(fluxes))])
disp('--')
%% Drone test(s)
testname = 'single channel drone signal test';
disp(testname)
filename = '9 6-Audio, steady whistling.wav';
[audio, Fs] = audioread(filename);
audioFrameMatrix = frameSegment(audio,c.FRAME_SIZE);

decisions = cell(size(audioFrameMatrix,2),1);
fluxes = zeros(1,size(audioFrameMatrix,2));
energies = zeros(1,size(audioFrameMatrix,2));
for i = 1:size(audioFrameMatrix,2)
    [decisions(i),fluxes(i),energies(i)] = system1.test(audioFrameMatrix(:,i));
end

% remove edge effects due to the smoothing filter 
energies = energies(c.TIME_SMOOTHING_LENGTH:length(energies));
fluxes = fluxes(c.TIME_SMOOTHING_LENGTH:length(fluxes));

% generate a feature space plot
figure;
plot(fluxes,energies,'o')
title(testname)
xlabel('Normalized spectral flux')
ylabel('Spectral energy')

disp(['mean/max energy: ', num2str(mean(energies)),'/', num2str(max(energies))])
disp(['mean/max flux: ', num2str(mean(fluxes)),'/', num2str(max(fluxes))])
disp('--')