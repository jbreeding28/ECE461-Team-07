% This function find the spectrum flux of an audio waveform, which is a
% measure of the change in the frequency spectrum over time. This is
% basically the derivateve of the frequency spectrum. The user can request
% a number of derivate values for the waveform. The more derivative values
% requested, the smaller abbount of time and smaples per segment. This
% makes the FFT less and less accurate as the segments get really small in
% size.
%
% Inputs:
%   waveform: the audio waveform that is examined in this function
%
%   segments: number of segments to break the waveform into and number of
%   derivative values to return to the user
%
%   overlap: number of samples to have the segments of the waveform overlap
%
% Outputs:
%   flux: an array of derivative values that indicate the change in the
%   overall frequency spectrum of an audio waveform over time
function flux = GetSpectrumFlux(waveform, segments, overlap)
%set up default values
if(nargin<3)
    overlap=0;
end
if(nargin<2)
    segments = 10;
end

    segmentLength = floor(length(waveform) / segments); %find an integer value for the segment length based on number of segments and the waveform length
    waveformSegments = zeros([segments,segmentLength + 2*overlap]); %create a matrix of zeros to segment the waveform into
    
    %segment the audio waveform and store it in the segments matrix
    for i = 1:segments
        if(i == 1)
            waveformSegments(i,:) = waveform(1:(segmentLength + overlap));
        elseif(i==segments)    
            waveformSegments(i,1:length(waveform(1 + (i-1) * segmentLength - overlap:end))) = waveform(1 + (i-1) * segmentLength - overlap:end);
        else
            waveformSegments(i,:) = waveform((1 + (i-1) * segmentLength - overlap):( segmentLength * (i) + overlap));
        end
    end
    
    flux = zeros([1,segments]); %create an array of flux values to return
    
    %perform the flux calculation for each waveform segment
    for (i=1:segments)   
    FFT = (abs(fft(waveformSegments(i,:)))); %take the FFT of the segment
    FFT = FFT / max(FFT); %normalize the FFT
    if (i>1)
        flux(i) = sum((FFT-FFTprev).^2); %find the difference in the current and previous FFT and square it
    else
        flux(i) = 0; %first flux value is zero becuase there is no change to observe
    end
    FFTprev = FFT; %set up the previous FFT value for later calculation
    end

end