function [ audioOut ] = rotorPass( audioIn, Fs )
%ROTORPASS Filter to block "non-rotor frequencies"
%   Most rotors fall in the range of 150Hz to 2000Hz (determined
%   empirically). This filter attempts to pass frequencies in that range.

    LO_CUT_HZ = 180;
    HI_CUT_HZ = 2000;
    
    [b,a] = butter(5,LO_CUT_HZ/(Fs/2),'high');
    audioOut = filter(b,a,audioIn);
    [b,a] = butter(5,HI_CUT_HZ/(Fs/2),'low');
    audioOut = filter(b,a,audioOut);
    
end

