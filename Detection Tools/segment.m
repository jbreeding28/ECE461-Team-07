function [ segmentsMatrix ] = segment( toSplit, numOfSegments )
%segment Splits a 1D array (toSplit) into several evenly-sized pieces. 
%   segmentsMatrix - Each column is one stretch of 'toSplit'.
%   toSplit - the 1D array to split
%   numOfSegments - the number of segments

    lengthPerSegment = floor(length(toSplit)/numOfSegments);
    disp(['# of disregarded samples: ' ...
        num2str(mod(length(toSplit),lengthPerSegment))])
    segmentsMatrix = zeros(numOfSegments,lengthPerSegment);
    for i = 1:numOfSegments
        segmentsMatrix(:,i) = ...
            toSplit((lengthPerSegment*(i-1)+1):(lengthPerSegment*(i)));
    end
    
end
