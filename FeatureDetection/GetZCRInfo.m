function [STZCR, avgZCR, ZCR] = GetZCRInfo(waveform, Fs, segments, overlap)
    if (nargin < 4)
        overlap = 0;
    end

    if (nargin < 3)
       segments = 10; 
    end
    
    if (nargin < 2)
       Fs = 44100; 
    end
    
    segmentLength = round(length(waveform) / segments);
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
    
    segmentSigns = sign(waveformSegments);
    segmentCrossingCounts = zeros([1,segments]);
    segmentZCRs = zeros([1,segments]);
    segmentTimes = zeros([1,segments]);
    previousCounted = 0;
    
    for i = 1:segments
        for j = 1:(length(segmentSigns(i,:))-2)
           if(segmentSigns(i,j) ~= segmentSigns(i,j+2)&&previousCounted==0)
               segmentCrossingCounts(i) = segmentCrossingCounts(i) + 1;
               previousCounted = 1;
           else
               previousCounted = 0;
           end         
        end
        segmentTimes(i) = length(waveformSegments(i,:))/Fs;
        segmentZCRs(i) = segmentCrossingCounts(i)/segmentTimes(i);
    end
    waveformTime = length(waveform)/Fs;
    STZCR = segmentZCRs;
    avgZCR = mean(segmentZCRs);
    ZCR = sum(segmentCrossingCounts)/waveformTime;   
end