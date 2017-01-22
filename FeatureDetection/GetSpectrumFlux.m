function flux = GetSpectrumFlux(waveform, segments, overlap)
if(nargin<3)
    overlap=0;
end
if(nargin<2)
    segments = 10;
end

    segmentLength = floor(length(waveform) / segments);

    waveformSegments = zeros([segments,segmentLength + 2*overlap]);
    for i = 1:segments
        if(i == 1)
            waveformSegments(i,:) = waveform(1:(segmentLength + overlap));
        elseif(i==segments)    
            waveformSegments(i,1:length(waveform(1 + (i-1) * segmentLength - overlap:end))) = waveform(1 + (i-1) * segmentLength - overlap:end);
        else
            waveformSegments(i,:) = waveform((1 + (i-1) * segmentLength - overlap):( segmentLength * (i) + overlap));
        end
    end
    flux = zeros([1,segments]);
    for (i=1:segments)   
    FFT = (abs(fft(waveformSegments(i,:))));
    FFT = FFT / max(FFT);
    if (i>1)
        flux(i) = sum((FFT-FFTprev).^2);
    else
        flux(i) = 0;
    end
    FFTprev = FFT;
    end

end