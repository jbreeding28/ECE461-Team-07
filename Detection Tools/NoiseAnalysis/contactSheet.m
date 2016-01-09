function [ hFig ] = contactSheet( audio, windowSize, overlap, Fs, cBoolean)
%CONTACTSHEET Generates a 4x4 contact sheet of FFTs
%   Displays the FFT of the first 16 windows of the input 'audio'
%   if cBoolean is true, the spectrum is conditioned

    MIN_F_HZ = 101;
    
    %frequencyPerBin = (Fs/2)/(windowSize/2+1);

    F_AXIS = linspace(0,Fs/2,windowSize/2+1);
    S = spectrogram(audio, windowSize, overlap);
    %S = S((MIN_F_HZ/frequencyPerBin:size(S,1)),:);
    % conditioning
    if(cBoolean)
        S = smoothSpectrogram(abs(S));
        
        for i = 1:size(S,2)
            slice = S(:,i);
            slice = meanRemovalFilter1(abs(slice),7);
            slice(slice<0) = 0;
            S(:,i) = slice;
        end
    end
    
    hFig = figure();
    
    for i = 1:16
       subplot(4,4,i)
       plot(F_AXIS,abs(S(:,i)))
       set(gca,'XScale','log','XLim',[100 max(F_AXIS)])
       subplotTitle = ['Start time: ', num2str((i-1)*windowSize/Fs)];
       if(cBoolean)
           subplotTitle = [subplotTitle, ', conditioned'];
       end
       title(subplotTitle);
    end
    
    
end