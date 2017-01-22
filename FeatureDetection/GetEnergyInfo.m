function [STE, STEavg, Energy] = GetEnergyInfo(waveform, segments, overlap)
if(nargin<3)
    overlap=0;
end
if(nargin<2)
    segments = 10;
end

    segmentLength = floor(length(waveform) / segments);
%     segmentCheck = mod(length(waveform),segmentLength);
%     if(segmentCheck ~= 0)
%         
%     end
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
    
    STE = zeros([1,segments]);
    
    for i = 1:segments
        STE(i) = sum(abs(waveformSegments(i,:).^2));%*(1/segmentLength);       
    end
    
    STEavg = mean(STE);
    
    Energy = sum(abs(waveform.^2));%*(1/length(waveform));

end