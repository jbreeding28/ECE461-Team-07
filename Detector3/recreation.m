% recreate drone noise
cosf = @(f,t) cos(2*pi*f*t);
Fs = 44100;
t0 = linspace(0,1,Fs);
f0 = 190;
simDroneSignal = cosf(f0,t0)+cosf(f0*2,t0)+cosf(f0*3,t0);
% what does messing with the phase of each one do?
%sound(simDroneSignal,Fs);


% to compare the fft and spectrogram
S = spectrogram(simDroneSignal,4096,2048);
S = abs(S);
f1frame = abs(fft(simDroneSignal(1:4096)))';