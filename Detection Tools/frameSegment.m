function [ segmentsMatrix ] = frameSegment( toSplit, frameSize )
%FRAMESEGMENT Splits a 1D array (toSplit) into several evenly-sized pieces. 
%   segmentsMatrix - Each column is one stretch of 'toSplit'.
%   toSplit - the 1D array to split
%   numOfSegments - the number of segments
%   Note: samples that do not fit nicely into the last frame will be
%   disregarded.

    numOfSegments = floor(length(toSplit)/frameSize);
    
    samplesDisregarded = mod(length(toSplit),frameSize);
    if(samplesDisregarded>0)
        warning([num2str(samplesDisregarded),' sample(s) disregarded']);
    end
    
    segmentsMatrix = zeros(frameSize,numOfSegments);
    for i = 1:numOfSegments
        segmentsMatrix(:,i) = ...
            toSplit((frameSize*(i-1)+1):(frameSize*(i)));
    end
    
end

