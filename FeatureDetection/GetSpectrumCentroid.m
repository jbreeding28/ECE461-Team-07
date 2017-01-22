function [Centroid, CentroidValue]= GetSpectrumCentroid(spectrum, fs)

if(nargin < 2)
    fs = 44100;
end

f = linspace( 0,fs/2,length(spectrum)/2);
spectrumPositiveHalf       = spectrum(round(length(spectrum)/2+1):round(length(spectrum)));
vsc     = ([0:size(spectrumPositiveHalf,1)-1]*spectrumPositiveHalf)./sum(spectrumPositiveHalf,1);
if(vsc<1)
    Centroid = 0;
else
Centroid = f(round(vsc));
end
CentroidValue = spectrumPositiveHalf(round(vsc));
% figure()
% plot(f,X,Centroid,X(round(vsc)),'red o');
end