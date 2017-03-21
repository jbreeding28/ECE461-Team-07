% This function caluculates three values based on the energy of
% an audio waveform. It finds the short-time energy, the average energy,
% and the overall energy of the waveform.
%
% Inputs:
%   waveform: audio wavefrom to analyze in this function
%
%   segments: number of segments to break the waveform into for the
%   short-time calculations.
%
%   overlap: the number of samples to overlap between aegments of the audio
%   waveform
%
% Outputs:
%   STE: short-time energy of the waveform
%
%   STEavg: the average of the STE segments
%
%   Energy: the total energy of the waveform
function [STE, STEavg, Energy] = GetEnergyInfo(waveform, segments, overlap)
%setup default values
if(nargin<3)
    overlap=0;
end
if(nargin<2)
    segments = 10;
end

    segmentLength = floor(length(waveform) / segments); %find an integer value for the segment length based on number of segments and the waveform length
    waveformSegments = zeros([segments,segmentLength + 2*overlap]);  %create a matrix of zeros to segment the waveform into
    
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
    
    STE = zeros([1,segments]); %create an array to hold the individual STE values
    
    %calculate the short term energy of each waveform segment
    for i = 1:segments
        STE(i) = sum(abs(waveformSegments(i,:).^2));      
    end
    
    STEavg = mean(STE); %average the STE of the semgents for the average energy
    
    Energy = sum(abs(waveform.^2));%*(1/length(waveform));

end