clear
% MATLAB autocorrelator

% define audio
filename = '9 6-Audio, steady whistling.wav';
[audio, Fs] = audioread(filename);
audio = audio(1:4096);

% define a frequency range
lo_f = 150;
hi_f = 400;

maximumLag = floor(1/lo_f*Fs);
minimumLag = floor(1/hi_f*Fs);

H = dsp.Autocorrelator('MaximumLagSource','Property','MaximumLag', ...
    maximumLag);
autoCor = step(H,audio); 

autoCor(1:minimumLag) = 0;
harmonicLag = find(autoCor == max(autoCor));

f0 = (harmonicLag/Fs)^-1;

if(autoCor(harmonicLag) > 1.5*mean(autoCor((minimumLag+1):length(autoCor))))
    disp('harmonic sequence')
end