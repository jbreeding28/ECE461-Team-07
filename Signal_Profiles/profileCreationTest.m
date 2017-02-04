% This is an example function call of CreateSignalProfile.m to show how
% data should be entered into the function call. Always store the waveforms
% and their corresponding frequency spectrums in colum vecotrs if entering
% a single waveforma and spectrum, or matrices where the individual
% waveforms and spectrums are the colums of the matrix if multiple
% waveforms and spectrums are being entered. 

clear all
close all
clc

audioData = audioinfo('IntramuralField_Drone_HighGain_1_1.wav');

fileNames = {'IntramuralField_Drone_HighGain_1_1.wav';
    'IntramuralField_Drone_HighGain_1_2.wav';
    'IntramuralField_Drone_HighGain_1_3.wav';
    'IntramuralField_Drone_HighGain_1_4.wav';
    'IntramuralField_Drone_HighGain_2_1.wav';
    'IntramuralField_Drone_HighGain_2_2.wav';
    'IntramuralField_Drone_HighGain_2_3.wav';
    'IntramuralField_Drone_HighGain_2_4.wav';
    'IntramuralField_Drone_HighGain_FarDistance_1.wav';
    'IntramuralField_Drone_HighGain_FarDistance_2.wav';
    'IntramuralField_Drone_HighGain_FarDistance_3.wav';
    'IntramuralField_Drone_HighGain_FarDistance_4.wav';
    'IntramuralField_Drone_CloseHover_1.wav';
    'IntramuralField_Drone_CloseHover_2.wav';
    'IntramuralField_Drone_CloseHover_3.wav';
    'IntramuralField_Drone_CloseHover_4.wav';};

numFiles = length(fileNames);
waveform = zeros([audioData.TotalSamples,numFiles]);
spectrum = zeros([audioData.TotalSamples,numFiles]);


for i = 1:numFiles
    waveform(:,i) = audioread(cast(fileNames(i),'char'));
    spectrum(:,i) = abs(fftshift(fft(waveform(:,i))));
end
CreateSignalProfile(waveform, audioData.SampleRate, spectrum)
load('Example_Automated_Profile.mat');