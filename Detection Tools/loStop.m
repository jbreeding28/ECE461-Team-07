function [ audioOut ] = loStop( audioIn, Fs )
%LOSTOP Filter to block wind and other low frequency noise sources
%   This is a relaxed version of the rotorPass filter

    LO_CUT_HZ = 180;
    
    [b,a] = butter(5,LO_CUT_HZ/(Fs/2),'high');
    audioOut = filter(b,a,audioIn);
    
end

