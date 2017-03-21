% This function finds all of the peaks in an audio waveforms frequency
% spectrum. It then takes into account the parameters passed in and finds
% the top number of peaks equal to the values parameter that are at least
% MPD apart from eachother.
%
%   A portion of this code was borrowed from an online Mathworks source
%   made available to the public. This code was used to determine all of 
%   the peaks in the spectrum before the qualifying parameters are applied.
%
% Inputs:
%   spectrum: the frequency spectrum of the audio waveform being examined
%
%   Fs: the sampling frequency of the audio being examined
%
%   value: the number of spectrum peaks to find
%
%   MPD: minimum peak distance between the peaks to find
%
% Outputs:
%   peaks: the amplitude values of the spectrum peaks
%
%   freqs: the frequency values that the spectrum peaks are located at
function [peaks, freqs] = GetPeaks(spectrum, Fs, values, MPD)
%set up default values
if (nargin < 4)
    MPD = 200;
end
if (nargin < 3)
    values = 5;
end

if nargin < 2
    Fs = 44100;
end

%--------------------------------------------------------------------------
%until further notice, this code is the borrowed code used to find the
%peaks in the spectrum
%--------------------------------------------------------------------------

len0 = numel(spectrum);
sel = (max(spectrum)-min(spectrum))/4;
dx0 = diff(spectrum); % Find derivative
dx0(dx0 == 0) = -eps; % This is so we find the first of repeated values
ind = find(dx0(1:end-1).*dx0(2:end) < 0)+1; % Find where the derivative changes sign

% Include endpoints in potential peaks and valleys as desired
    x = [spectrum(1);spectrum(ind);spectrum(end)];
    ind = [1;ind;len0];
    minMag = min(x);
    leftMin = minMag;


% x only has the peaks, valleys, and possibly endpoints
len = numel(x);

if len > 2 % Function with peaks and valleys
    % Set initial parameters for loop
    tempMag = minMag;
    foundPeak = false;


        % Deal with first point a little differently since tacked it on
        % Calculate the sign of the derivative since we tacked the first
        %  point on it does not neccessarily alternate like the rest.
        signDx = sign(diff(x(1:3)));
        if signDx(1) <= 0 % The first point is larger or equal to the second
            if signDx(1) == signDx(2) % Want alternating signs
                x(2) = [];
                ind(2) = [];
                len = len-1;
            end
        else % First point is smaller than the second
            if signDx(1) == signDx(2) % Want alternating signs
                x(1) = [];
                ind(1) = [];
                len = len-1;
            end
        end


    % Skip the first point if it is smaller so we always start on a
    %   maxima
    if x(1) >= x(2)
        ii = 0;
    else
        ii = 1;
    end

    % Preallocate max number of maxima
    maxPeaks = ceil(len/2);
    peakLoc = zeros(maxPeaks,1);
    peakMag = zeros(maxPeaks,1);
    cInd = 1;
    % Loop through extrema which should be peaks and then valleys
    while ii < len
        ii = ii+1; % This is a peak
        % Reset peak finding if we had a peak and the next peak is bigger
        %   than the last or the left min was small enough to reset.
        if foundPeak
            tempMag = minMag;
            foundPeak = false;
        end

        % Found new peak that was lager than temp mag and selectivity larger
        %   than the minimum to its left.
        if x(ii) > tempMag && x(ii) > leftMin + sel
            tempLoc = ii;
            tempMag = x(ii);
        end

        % Make sure we don't iterate past the length of our vector
        if ii == len
            break; % We assign the last point differently out of the loop
        end

        ii = ii+1; % Move onto the valley
        % Come down at least sel from peak
        if ~foundPeak && tempMag > sel + x(ii)
            foundPeak = true; % We have found a peak
            leftMin = x(ii);
            peakLoc(cInd) = tempLoc; % Add peak to index
            peakMag(cInd) = tempMag;
            cInd = cInd+1;
        elseif x(ii) < leftMin % New left minima
            leftMin = x(ii);
        end
    end

    % Check end point
        if x(end) > tempMag && x(end) > leftMin + sel
            peakLoc(cInd) = len;
            peakMag(cInd) = x(end);
            cInd = cInd + 1;
        elseif ~foundPeak && tempMag > minMag % Check if we still need to add the last point
            peakLoc(cInd) = tempLoc;
            peakMag(cInd) = tempMag;
            cInd = cInd + 1;
        end


    % Create output
    if cInd > 1
        peakInds = ind(peakLoc(1:cInd-1));
        peakMags = peakMag(1:cInd-1);
    else
        peakInds = [];
        peakMags = [];
    end
else % This is a monotone function where an endpoint is the only peak
    [peakMags,xInd] = max(x);
    if includeEndpoints && peakMags > minMag + sel
        peakInds = ind(xInd);
    else
        peakMags = [];
        peakInds = [];
    end
end


% Plot if no output desired
    if isempty(peakInds)
        disp('No significant peaks found')
    else
%         figure;
%         plot(peakInds,peakMags); %1:len0,spectrum,'.-',
    end
    envelopedSpectrum = {peakInds,peakMags};
if(mod(length(peakMags),2) == 0)
thing = peakMags(round(length(peakMags)/2)+1:round(length(peakMags)));
stuff = peakInds(round(length(peakInds)/2)+1:round(length(peakInds)));
else
thing = peakMags(round(length(peakMags)/2)-0.5:round(length(peakMags)));
stuff = peakInds(round(length(peakInds)/2)-0.5:round(length(peakInds)));
end

if(mod(length(spectrum),2) == 0)
    spectrum = spectrum(length(spectrum)/2+1:end);
else
    spectrum = spectrum(length(spectrum)/2-0.5:end);
end
f = linspace(0,Fs/2,length(spectrum)); 
peakFreqsIndices = stuff-length(spectrum);
for i = 1:length(peakFreqsIndices)
    if(peakFreqsIndices(i) > 0)
        peakFreqs(i) = f(peakFreqsIndices(i));        
    end
end
%figure();
%plot(f,spectrum,peakFreqs,thing,'r');

%--------------------------------------------------------------------------
%after this point, the code was independantly written and not bottowed
%--------------------------------------------------------------------------

[sortedValue, sortedIndex] = sort(peakMags(ceil(length(peakMags)/2)+1:floor(length(peakMags))),'descend');
pointsToSave = zeros([1,values]);
peakValue = zeros([1,values]);
temp = zeros([1,values]);
foundCount = 1;
check = 1;
if(values > 1)
     for i = 1:(length(peakFreqs)-1)
         if(i == 1)
             pointsToSave(foundCount) = sortedIndex(i);
             peakValue(foundCount) = sortedValue(i);
             foundCount = foundCount + 1;
         
         else
             check = 1;
             for j = 1:(foundCount - 1)
                 %i
                 %j
                 %sortedIndexLength = length(sortedIndex)
                 %peakFreqsLength = length(peakFreqs)
                 %pointsToSaveLength = length(pointsToSave)
                 %pointToSave = peakFreqs(pointsToSave(j))
                 %sortedIndexCheck = sortedIndex(i)
                 %sortedFreq = peakFreqs(sortedIndex(i))
                 if((sortedIndex(i)<=length(peakFreqs))&&abs(peakFreqs(pointsToSave(j)) - peakFreqs(sortedIndex(i))) < MPD)
                     check = 0;
                 elseif((sortedIndex(i)>length(peakFreqs)))
                     check=0;
                 end
             end
             if(check == 1)%abs((peakFreqs(sortedIndex(i-1)) - peakFreqs(sortedIndex(i)))) > MPD)
             pointsToSave(foundCount) = sortedIndex(i);
             peakValue(foundCount) = sortedValue(i);
             foundCount = foundCount + 1;
             end
         end
         %foundCount
         if(foundCount > values)
             break;
         end
         
     end
end
peaks = zeros([1,values]);
freqs = zeros([1,values]);
for i = 1:length(pointsToSave)
    if(pointsToSave(i) > 0)
        peaks(i) = peakValue(i);
        freqs(i) = peakFreqs(pointsToSave(i));
    end
end
% [peaks, indices] = findpeaks(peakMags,'MinPeakDistance', MPD);%, 'NPeaks', values);
% freqs = f(indices);
% figure();
% plot(f,spectrum,'blue',freqs,peaks,'red o');
end



