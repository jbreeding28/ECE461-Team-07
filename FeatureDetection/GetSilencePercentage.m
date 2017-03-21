% This function calculates the percentage of a waveform that is considered
% to be silence based on a threshold, or basline value.
%
% Inputs:
%   waveform: the audio waveform being examined by this feature
%
%   Fs: the sampling frequency that the waveform was captured at
%
%   threshold: A proportion value between 0 and 1 that is used to determine
%   the statistical value that will be used to determine what amplitude
%   value is the cutoff for silence. The default is 0.15 or 15% of the
%   waveform's median value. It is recommended that this parameter goes 
%   unused by passing in a 0 for it. The statistics have not been worked 
%   out properly yet.
%
%   baseline: A straight baseline value for the audio amplitude to compare
%   as the silence threshold.
%
%   note: between baseline and threshold, the parameter that produces a
%   lower comparison value will be used. That is why baseline can be used
%   with whatever value if threshold is passed in as 0.
%
% Outputs:
%   percentage: The percentage of the audio waveform that is considered
%   silence.
function percentage = GetSilencePercentage(waveform, Fs, threshold,baseline)
%Set up default values for missing parameters
if (nargin < 4)
    baseline = 0.005;
end

if (nargin < 3)
    threshold = 0.15;
end
if (nargin < 2)
    Fs = 44100;
end

%Useful only for creating plots when debugging function
%S = abs(fftshift(fft(waveform)));
%f = linspace(-Fs/2,Fs/2,length(S)); 
order = 5; %order of the envelope filter
Fc = 100; %cutoff frequency for the envelope filter

absWaveform = abs(waveform); %take the absolute value of the audio waveform
[b,a] = butter(order, Fc/(Fs/2),'low'); %create a butterworth filter to use for enveloping the audio waveform
Envelope = filter(b,a,absWaveform);% filter the audio waveform to get an envelope

%attempt to calculate a thresholding value using the threshold parameter and the median value of the waveform
thresholdValue = threshold*median(absWaveform); 

%compare the theshold's result with the baseline value and use the lower
%for the actual thresholding value
if (baseline > thresholdValue)
    thresholdValue = baseline;
end

%  figure();
%  thresholdPlot = thresholdValue*ones([length(waveform),1]);
%  hold on 
%  plot(waveform,'blue'); 
%  plot(Envelope,'red','LineWidth',1);
%  plot(thresholdPlot, ' black','LineWidth',1)
%  hold off


silenceCount = 0; %number of samples in the waveform that are considered silent

%iterate through the waveform and count the number of samples that are
%below the thresholdValue
for i = 1:length(Envelope)
    if(Envelope(i)< thresholdValue)
        silenceCount = silenceCount + 1;
    end
end

%divide the silence count by the waveform length and multiply by 100 to get
%a percentage for the silence
percentage = 100 * silenceCount / length(Envelope);


end