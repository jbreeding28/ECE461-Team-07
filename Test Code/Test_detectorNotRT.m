clear
%% INFO

% (1) is weak signal
% (2) is a highly non stationary signal
% (3) is a non-drone oscillator
% (4) is a drone oscillator

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
    [decisions(i),fluxes(i),energies(i)] = system1.test(audioFrameMatrix(:,i));
    if(decisions{i}~=correct)
        failedDecisionIndexes = [failedDecisionIndexes; i];
    end
end

% remove edge effects due to the smoothing filter 
energies = energies(c.TIME_SMOOTHING_LENGTH:length(energies));
fluxes = fluxes(c.TIME_SMOOTHING_LENGTH:length(fluxes));
decisions = decisions(c.TIME_SMOOTHING_LENGTH:length(decisions));

% generate a feature space plot
figure;
subplot(2,1,1)
plot(fluxes,energies,'o')
title(testname)
xlabel('Normalized spectral flux')
ylabel('Spectral energy')
subplot(2,1,2)
hist(cell2mat(decisions),4)

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
decisions = decisions(c.TIME_SMOOTHING_LENGTH:length(decisions));

% generate a feature space plot
figure;
subplot(2,1,1)
plot(fluxes,energies,'o')
title(testname)
xlabel('Normalized spectral flux')
ylabel('Spectral energy')
subplot(2,1,2)
hist(cell2mat(decisions),4)

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
decisions = decisions(c.TIME_SMOOTHING_LENGTH:length(decisions));

% generate a feature space plot
figure;
subplot(2,1,1)
plot(fluxes,energies,'o')
title(testname)
xlabel('Normalized spectral flux')
ylabel('Spectral energy')
subplot(2,1,2)
hist(cell2mat(decisions),4)

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
decisions = decisions(c.TIME_SMOOTHING_LENGTH:length(decisions));

% generate a feature space plot
figure;
subplot(2,1,1)
plot(fluxes,energies,'o')
title(testname)
xlabel('Normalized spectral flux')
ylabel('Spectral energy')
subplot(2,1,2)
hist(cell2mat(decisions),4)

disp(['mean/max energy: ', num2str(mean(energies)),'/', num2str(max(energies))])
disp(['mean/max flux: ', num2str(mean(fluxes)),'/', num2str(max(fluxes))])
disp('--')

%% Drone test(s)
testname = 'test for distinction between class (3) and (4)';
disp(testname)
filename = 'from1to2_01.wav';
[audio, Fs] = audioread(filename);
% extract a loud snippet (drone is right overhead)
audio = audio(2.455e05:8.8e05);
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
decisions = decisions(c.TIME_SMOOTHING_LENGTH:length(decisions));

% generate a feature space plot
figure;
subplot(2,1,1)
plot(fluxes,energies,'o')
title(testname)
xlabel('Normalized spectral flux')
ylabel('Spectral energy')
subplot(2,1,2)
hist(cell2mat(decisions),4);

disp(['mean/max energy: ', num2str(mean(energies)),'/', num2str(max(energies))])
disp(['mean/max flux: ', num2str(mean(fluxes)),'/', num2str(max(fluxes))])
disp('--')