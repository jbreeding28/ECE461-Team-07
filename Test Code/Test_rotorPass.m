[audioData,Fs] = audioread('9 6-Audio, steady whistling.wav');
X = fft(audioData);
X = X(1:floor(length(X)/2));
F_axis = linspace(0,Fs/2,length(X));
subplot(2,1,1)
plot(F_axis,abs(X))
set(gca,'XScale','log');
Xfilt = fft(rotorPass(audioData,Fs));
Xfilt = Xfilt(1:floor(length(Xfilt)/2));
subplot(2,1,2)
plot(F_axis,abs(Xfilt));
set(gca,'XScale','log');

disp('Test by inspection.')
disp('Signal should be bandpassed, cutoff frequencies defined in rotorPass.m.')