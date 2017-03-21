% This function calculates the spectrum centroid of a given spectrum. It
% does so using jut the spectrum and the sampling frequency that the audio
% was sampled at.
%
% Inputs:
%   spectrum: The frequency spectrum of the audio waveform being examined
%   by this feature. It can be any length of samples as long as the Fs is
%   included to account for that length in the math.
%
%   fs: The sampling frequency of the autio being examined in this file.
%   This value defaults to 44100 Hz if not included in the function call.
%
% Outputs:
%   Centroid: The frequency value of the spectrum where the spectrum
%   centroid is located. It's like the x portion of an (x,y) coordinate.
%
%   CentroidValue: The amplitude value of the spectrum centroid. It's like
%   the y portion of an (x,y) coordinate.
function [Centroid, CentroidValue]= GetSpectrumCentroid(spectrum, fs)

%default setup for the sampling frequency
if(nargin < 2)
    fs = 44100;
end


f = linspace( 0,fs/2,length(spectrum)/2); %Create a range of frequencies from 0 to half the sampling frequency
spectrumPositiveHalf = spectrum(round(length(spectrum)/2+1):round(length(spectrum))); %find the positive frequency half of the spectrum

%perform the weighted average value to find the spectrum centroid value in
%terms of sample indice
vsc = ([0:size(spectrumPositiveHalf,1)-1]*spectrumPositiveHalf)./sum(spectrumPositiveHalf,1);

%convert the sample indice into an actual frequency value
if(vsc<1)
    Centroid = 0;
else
Centroid = f(round(vsc));
end

%use the sample indice to get the amplitude value of the spectrum centroid
CentroidValue = spectrumPositiveHalf(round(vsc));
% figure()
% plot(f,X,Centroid,X(round(vsc)),'red o');
end