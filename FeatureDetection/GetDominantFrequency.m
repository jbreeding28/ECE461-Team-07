function [peakValue, peakFreq] = GetDominantFrequency(spectrum, Fs, values)
if(nargin < 2)
   values = 1;
   Fs = 44100;
end

f = linspace(-Fs/2,Fs/2,length(spectrum)); 
[sortedValue, sortedFreqIndex] = sort(spectrum(round(length(spectrum)/2):round(length(spectrum))),'descend');
%sortedFreqIndex = sortedFreqIndex + length(S)/2;
% pointsToSave = zeros([1,values]);
% peakValue = zeros([1,values]);
% pointsToSave(1) = sortedFreqIndex(1);
%foundCount = 1;
% if(values > 1)
%     for i = 2:(length(S)/2)
%         if(sortedFreqIndex(i-1) - sortedFreqIndex(i) > pointDiff)
%             pointsToSave(foundCount) = sortedFreqIndex(i);
%             peakValue(foundCount) = sortedValue(i);
%             foundCount = foundCount + 1;
%         end
%         if(foundCount >= values)
%             i = length(S)/2;
%         end
%         
%     end
% % end
% 
% pointsToSave = pointsToSave + length(S)/2;
peakValue = sortedValue(1:values);
peakFreq = f(round(sortedFreqIndex(1:values) + length(f)/2));
% figure();
% plot(f,S,peakFreq,peakValue,'red o');
% xlim([0, Fs/2]);
end