function [ zone, compass ] = directionFinder(pwrs);

% Written by Robert Vargo
% ECE senior design team 12, 2016-17
% Client: NSWC Crane
% 
% This function is meant to identify in what direction a detected drone is.
% It attempts to decide between 30* sections. If a section is not
% determinable, it will default to the most accurate quadrant of N, W, S,
% or E.
% 
% The code's inner structure consists of looking for the strongest
% microphone, then comparing powers amongst all the microphones to
% determine an appropriate sector. If no microphone is stronger, the system
% defaults to an inside detection.
%
% Power value comparisons are based on data taken from field testing the
% drone's power levels at division points along sectors.
%
% 3 sections per quadrant --> 12 sections --> 30 degree cones
% Mic 1: NNE, N, NNW
% Mic 2: WNW, W, WSW
% Mic 3: SSW, S, SSE
% Mic 4: ESE, E, ENE
% 

pwrDB1 = pwrs(1); % mic 1 in dB
pwrDB2 = pwrs(2);
pwrDB3 = pwrs(3); % mic's reversed???
pwrDB4 = pwrs(4);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% North (mic 1)

if ( (pwrDB1 >= pwrDB2) && (pwrDB1 >= pwrDB3) && (pwrDB1 >= pwrDB4) )
    
    if ( ( (pwrDB1 >= (pwrDB2 * 0.65)) && (pwrDB1 >= (pwrDB3 * 0.63)) && (pwrDB1 >= (pwrDB4 * 0.75)) ) || ( (pwrDB1 >= (pwrDB2 * 0.75)) && (pwrDB1 >= (pwrDB3 * 0.63)) && (pwrDB1 >= (pwrDB4 * 0.65)) ) )
        zone = 1;
        compass = 'North';
        
    elseif ( ((pwrDB1 >= (pwrDB2 * 0.875)) && (pwrDB1 >= (pwrDB3 * 0.875)) && (pwrDB1 >= (pwrDB4 * 1))) && ( (pwrDB1 <= (pwrDB2 * 0.65)) && (pwrDB1 <= (pwrDB3 * 0.63)) && (pwrDB1 <= (pwrDB4 * 0.75)) ) )
        zone = 2;
        compass = 'North North East';
        
    elseif (  ((pwrDB1 >= (pwrDB2 * 1)) && (pwrDB1 >= (pwrDB3 * 0.875)) && (pwrDB1 >= (pwrDB4 * 0.875))) && ( (pwrDB1 <= (pwrDB2 * 0.75)) && (pwrDB1 <= (pwrDB3 * 0.63)) && (pwrDB1 <= (pwrDB4 * 0.65)) ) )
        zone = 12;
        compass = 'North North West';
        
    else
        compass = 'North';
        zone = 13;
    end
           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% West (mic 2)
        
elseif ( (pwrDB2 >= pwrDB1) && (pwrDB2 >= pwrDB3) && (pwrDB2 >= pwrDB4) )
    
    if ( ( (pwrDB2 >= (pwrDB3 * 0.65)) && (pwrDB2 >= (pwrDB4 * 0.63)) && (pwrDB2 >= (pwrDB1 * 0.75)) ) || ( (pwrDB2 >= (pwrDB3 * 0.75)) && (pwrDB2 >= (pwrDB4 * 0.63)) && (pwrDB2 >= (pwrDB1 * 0.65)) ) )
        zone = 10;
        compass = 'West';
        
    elseif ( ((pwrDB2 >= (pwrDB3 * 0.875)) && (pwrDB2 >= (pwrDB4 * 0.875)) && (pwrDB2 >= (pwrDB1 * 1))) && ( (pwrDB2 <= (pwrDB3 * 0.65)) && (pwrDB2 <= (pwrDB4 * 0.63)) && (pwrDB2 <= (pwrDB1 * 0.75)) ) )
        zone = 11;
        compass = 'West North West';
        
    elseif (  ((pwrDB2 >= (pwrDB3 * 1)) && (pwrDB2 >= (pwrDB4 * 0.875)) && (pwrDB2 >= (pwrDB1 * 0.875))) && ( (pwrDB2 <= (pwrDB3 * 0.75)) && (pwrDB2 <= (pwrDB4 * 0.63)) && (pwrDB2 <= (pwrDB1 * 0.65)) ) )
        zone = 9;
        compass = 'West South West';
        
    else
        compass = 'West';
        zone = 16;
    end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% East (mic 4)

elseif ( (pwrDB4 >= pwrDB1) && (pwrDB4 >= pwrDB3) && (pwrDB4 >= pwrDB2) )
    
    if ( ( (pwrDB4 >= (pwrDB1 * 0.65)) && (pwrDB4 >= (pwrDB2 * 0.63)) && (pwrDB4 >= (pwrDB3 * 0.75)) ) || ( (pwrDB4 >= (pwrDB1 * 0.75)) && (pwrDB4 >= (pwrDB2 * 0.63)) && (pwrDB4 >= (pwrDB3 * 0.65)) ) )
        zone = 4;
        compass = 'East';
        
    elseif ( ((pwrDB4 >= (pwrDB1 * 0.875)) && (pwrDB4 >= (pwrDB2 * 0.875)) && (pwrDB4 >= (pwrDB3 * 1))) && ( (pwrDB4 <= (pwrDB1 * 0.65)) && (pwrDB4 <= (pwrDB2 * 0.63)) && (pwrDB4 <= (pwrDB3 * 0.75)) ) )
        zone = 5;
        compass = 'East South East';
        
    elseif (  ((pwrDB4 >= (pwrDB1 * 1)) && (pwrDB4 >= (pwrDB2 * 0.875)) && (pwrDB4 >= (pwrDB3 * 0.875))) && ( (pwrDB4 <= (pwrDB1 * 0.75)) && (pwrDB4 <= (pwrDB2 * 0.63)) && (pwrDB4 <= (pwrDB3 * 0.65)) ) )
        zone = 3;
        compass = 'East North East';
        
    else
        compass = 'East';
        zone = 14;
    end
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% South (mic 3)

elseif ( (pwrDB3 >= pwrDB1) && (pwrDB3 >= pwrDB2) && (pwrDB3 >= pwrDB4) )
    
    if ( ( (pwrDB3 >= (pwrDB4 * 0.65)) && (pwrDB3 >= (pwrDB1 * 0.63)) && (pwrDB3 >= (pwrDB4 * 0.75)) ) || ( (pwrDB3 >= (pwrDB4 * 0.75)) && (pwrDB3 >= (pwrDB1 * 0.63)) && (pwrDB3 >= (pwrDB2 * 0.65)) ) )
        zone = 7;
        compass = 'South';
        
    elseif ( ((pwrDB3 >= (pwrDB4 * 0.875)) && (pwrDB3 >= (pwrDB1 * 0.875)) && (pwrDB3 >= (pwrDB2 * 1))) && ( (pwrDB3 <= (pwrDB4 * 0.65)) && (pwrDB3 <= (pwrDB1 * 0.63)) && (pwrDB3 <= (pwrDB2 * 0.75)) ) )
        zone = 8;
        compass = 'South South West';
        
    elseif (  ((pwrDB3 >= (pwrDB4 * 1)) && (pwrDB3 >= (pwrDB1 * 0.875)) && (pwrDB3 >= (pwrDB2 * 0.875))) && ( (pwrDB3 <= (pwrDB4 * 0.75)) && (pwrDB3 <= (pwrDB1 * 0.63)) && (pwrDB3 <= (pwrDB2 * 0.65)) ) )
        zone = 6;
        compass = 'South South East';
        
    else
        compass = 'South';
        zone = 15;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If no zone discernable
else
    compass = 'inside?';
    zone = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

end