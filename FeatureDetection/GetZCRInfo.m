% This function caluculated three values based on the zcro-crossing rate of
% an audio waveform. It finds the short-time zero-crossing rate, the
% average short-time zero-crossing rate, and the overall zero-crossing
% rate.
%
% Inputs:
%   waveform: audio wavefrom to analyze in this function
%
%   Fs: sampling frequency of the audio waveform
%
%   segments: number of segments to break the waveform into for the
%   short-time calculations.
%
%   overlap: the number of samples to overlap between aegments of the audio
%   waveform
%
% Outputs:
%   STZCR: short-time zero-crossing rate of the waveform
%
%   avgZCR: the average of the STZCR segments
%
%   ZCR: the zero-crossing rate of the waveform
function [STZCR, avgZCR, ZCR] = GetZCRInfo(waveform, Fs, segments, overlap)
%setup default values
    if (nargin < 4)
        overlap = 0;
    end

    if (nargin < 3)
       segments = 10; 
    end
    
    if (nargin < 2)
       Fs = 44100; 
    end
    
    segmentLength = round(length(waveform) / segments); %find an integer value for the segment length based on number of segments and the waveform length
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
    
    
    segmentSigns = sign(waveformSegments); %find the sign values of the waveform numbers in the segments
    segmentCrossingCounts = zeros([1,segments]); %create a variable to hold the times the sign changes in a segment
    segmentZCRs = zeros([1,segments]); %variable to hold the zero crossing rates of the segments
    segmentTimes = zeros([1,segments]); %variable to hold the length of the segments
    previousCounted = 0; %flag variable to keep prevent over counting
    
    %count the number of zero crossings in each audio waveform segment
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
    
    waveformTime = length(waveform)/Fs; %find the time duration of the audio waveform
    STZCR = segmentZCRs; 
    avgZCR = mean(segmentZCRs); %average the STZCR's to find the average ZCR value
    ZCR = sum(segmentCrossingCounts)/waveformTime; %add up all of the zero crossings and then divide by the total waveform time duration to find the overall ZCR
end