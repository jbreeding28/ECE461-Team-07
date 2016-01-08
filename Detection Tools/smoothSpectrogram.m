function [ S_smooth ] = smoothSpectrogram( S )
%smoothSpectrogram A function that cleans up the spectrogram
%   Supposed to take a spectrogram and clean up noise and smooth things out
%   in frequency and time
    

    S_smooth = zeros(size(S,1),size(S,2));
    
    % smooth things out in frequency
    for i = 1:size(S,2)
        S_smooth(:,i) = filter2(1/1*ones(1,1), abs(S(:,i)));
    end
    
    % smooth things out in time
    for i = 1:size(S,1)
        % the 1D median filter is slow
        %S_smooth(i,:) = medfilt1(S_smooth(i,:),8);
        S_smooth(i,:) = filter2(1/4*ones(1,4),S_smooth(i,:));
    end



end

