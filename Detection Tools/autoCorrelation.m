% MATLAB autocorrelator

filename = '9 6-Audio, steady whistling.wav';
[audio, Fs] = audioread(filename);

maximumLag = floor(1/150*Fs);

H = dsp.Autocorrelator('MaximumLagSource','Property','MaximumLag', ...
    maximumLag);
autoCor = step(H,audio);
