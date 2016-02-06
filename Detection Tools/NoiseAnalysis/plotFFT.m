clear
filename = '9 6-Audio, steady whistling.wav';
[audio, Fs] = audioread(filename);
% audio = audio(1:4096);
%audio = cos(2*pi*1000*linspace(0,1,44100));
spectrum = abs(fft(audio));
spectrum = spectrum(1:floor(length(audio)/2));
F_AXIS = linspace(0,Fs/2,length(spectrum));
plot(F_AXIS,spectrum)
[harmRatio, f0] = feature_harmonic(audio,Fs);