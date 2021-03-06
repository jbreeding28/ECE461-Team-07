clear all;
[y,fs] = audioread('CookField_OddDetectionScenario_1.wav');
[b,a] = butter(3,2000/44100,'high');
%sampleLength = 4096;
%in_fismat=genfis1(data, mf_n);
%out_fismat = anfis(data, in_fismat, [nan nan ss]);
%estimatedNoise = evalfis(data(:,1:2),out_fismat);
%estimatedSignal = ySignal - estimatedNoise;
T = 1/fs;
t = linspace(1,length(y)/44100,length(y));
L = length(y);
f = fs*((-L/2):(L/2)-1)/L;
figure();
ySignal = filter(b,a,y);
signalTransform = abs(fftshift(fft(ySignal(:,1))));
plot(f/1000,signalTransform);
%plot((ySignal(:,1)));
%plot(ySignal);
xlabel('Frequency (kHz)');
%ylim([0 30]);
xlim([0 22]);
title('Signal');