% This is an example function call of CreateSignalProfile.m to show how
% data should be entered into the function call. Always store the waveforms
% and their corresponding frequency spectrums in colum vecotrs if entering
% a single waveforma and spectrum, or matrices where the individual
% waveforms and spectrums are the colums of the matrix if multiple
% waveforms and spectrums are being entered. 

clear all
close all
clc

audioData = audioinfo('IMField_Wind_MaxGain_1.wav');

fileNames = {'IMField_Wind_MaxGain_1.wav';
    'IMField_Wind_MaxGain_2.wav';
    'IMField_Wind_MaxGain_3.wav';
    'IMField_Wind_MaxGain_3.wav';
    'IMField_Wind_MaxGain2_1.wav';
    'IMField_Wind_MaxGain2_2.wav';
    'IMField_Wind_MaxGain2_3.wav';
    'IMField_Wind_MaxGain2_4.wav';
    'IntramuralField_Environment_HighGain_1_1.wav';
    'IntramuralField_Environment_HighGain_1_2.wav';
    'IntramuralField_Environment_HighGain_1_3.wav';
    'IntramuralField_Environment_HighGain_1_4.wav';
    'IntramuralField_Environment_HighGain_2_1.wav';
    'IntramuralField_Environment_HighGain_2_2.wav';
    'IntramuralField_Environment_HighGain_2_3.wav';
    'IntramuralField_Environment_HighGain_2_4.wav';
    };

numFiles = length(fileNames);
waveform = zeros([audioData.TotalSamples,numFiles]);
spectrum = zeros([audioData.TotalSamples,numFiles]);


for i = 1:numFiles
    i
    waveform(:,i) = audioread(cast(fileNames(i),'char'));
    spectrum(:,i) = abs(fftshift(fft(waveform(:,i))));
end
CreateSignalProfile(waveform, audioData.SampleRate, spectrum)