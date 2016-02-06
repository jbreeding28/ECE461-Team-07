% recreate drone noise
cosf = @(f,t,a,p) a*cos(2*pi*(f.*t+p));
Fs = 44100;
t0 = linspace(0,1,Fs);
f0 = 189.3;
simDroneSignal = cosf(f0,t0,1,0.4)+cosf(367.8,t0,0.8,0.1)+ ...
    cosf(570.8,t0,0.6,0)+cosf(1.781e4,t0,0.2,0.23)+0.08*randn(1,44100);
% what does messing with the phase of each one do?
sound(simDroneSignal,Fs);


% to compare the fft and spectrogram
S = spectrogram(simDroneSignal,4096,2048);
S = abs(S);
f1frame = abs(fft(simDroneSignal(1:4096)))';