function [Centroid, CentroidValue]= GetSpectrumCentroid(waveform, fs, orientation)
if(nargin == 2)
    orientation = 'column';
end

if(nargin == 1)
    fs = 44100;
    orientation = 'column';
end

if(strcmp(orientation,'column'))
Y = abs(fftshift(fft(waveform(:,1))));
end
if(strcmp(orientation,'row'))
Y = abs(fftshift(fft(waveform(1,:).')));
end
f = linspace( 0,fs/2,length(Y)/2);
X       = Y(round(length(Y)/2+1):round(length(Y)));
vsc     = ([0:size(X,1)-1]*X)./sum(X,1);
if(isnan(vsc))
    Centroid = 0;
    vsc = 1;
elseif(vsc<1)
    Centroid = 0;
    vsc = 1;
else
    Centroid = f(round(vsc));
end
CentroidValue = X(round(vsc));
% figure()
% plot(f,X,Centroid,X(round(vsc)),'red o');
end