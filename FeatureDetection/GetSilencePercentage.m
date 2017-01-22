function percentage = GetSilencePercentage(waveform, Fs, threshold,baseline)
if (nargin < 4)
    baseline = 0.005;
end

if (nargin < 3)
    threshold = 0.15;
end
if (nargin < 2)
    Fs = 44100
end
S = abs(fftshift(fft(waveform)));
f = linspace(-Fs/2,Fs/2,length(S)); 
order = 5;
Fc = 50;

absWaveform = abs(waveform);
[b,a] = butter(order, Fc/(Fs/2),'low');
Envelope = filter(b,a,absWaveform);
thresholdValue = threshold*median(absWaveform);
if (baseline > thresholdValue)
    thresholdValue = baseline;
end
%thresholdPlot = thresholdValue*ones([length(waveform),1]);
%plot(Envelope,'red');
%hold on 
%plot(waveform,'blue');
%plot(thresholdPlot, ' black')
%hold off


silenceCount = 0;

for i = 1:length(Envelope)
    if(Envelope(i)< thresholdValue)
        silenceCount = silenceCount + 1;
    end
end
%here = 1
percentage = 100 * silenceCount / length(Envelope);


end