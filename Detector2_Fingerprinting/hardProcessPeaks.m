function [ detected, noisyInput ] = hardProcessPeaks( pks, locs )
%HARDPROCESSPEAKS Hardcoded processing of peaks
%   At this point, we can just take the peak information and try to
%   determine what we're looking at in a hardcoded manner.
    
    TOO_MANY_PEAKS = 10;
    
    detected = 0;
    noisyInput = 0;
    
    if(length(pks) >= TOO_MANY_PEAKS)
        % this does NOT work
        warning('Powerful noise source detected');
        noisyInput = 1;
    else
        % obviously, this will need to change
        if(length(pks) >= 3)
            detected = 1;
            disp('Drone detected')
        end
        
    end
    

end

