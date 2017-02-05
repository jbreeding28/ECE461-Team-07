function [ zone, compass ] = location_v3(pwrs);
% Drone dB gains range from -89 dB (undetected) to -60 dB (Immediately next to the microphone)

% speed of sound = 340.29 m/s

% Inverse squared law?

% 3 sections per quadrant --> 12 sections --> 30 degree cones
% Biased for N,NNE,ENE,E,ESE,SSE,S, etc in that order where mic 1 is
% "north" and mic 4 is "east"

% mic "1" is at the north segment?

% 1.4833 (60 to 89) or 0.6742 (89 to 60)

pwrDB1 = pwrs(4); % mic 1 in dB
pwrDB2 = pwrs(3);
pwrDB3 = pwrs(2);  % mic's reversed???
pwrDB4 = pwrs(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( (pwrDB1 >= pwrDB2) && (pwrDB1 >= pwrDB3) && (pwrDB1 >= pwrDB4) )
    
    if ( ( (pwrDB1 >= (pwrDB2 * 0.7)) && (pwrDB1 >= (pwrDB3 * 0.68)) && (pwrDB1 >= (pwrDB4 * 0.8)) ) || ( (pwrDB1 >= (pwrDB2 * 0.8)) && (pwrDB1 >= (pwrDB3 * 0.68)) && (pwrDB1 >= (pwrDB4 * 0.7)) ) )
        zone = 1;
        compass = 'North';
        
    elseif ( ((pwrDB1 >= (pwrDB2 * 0.925)) && (pwrDB1 >= (pwrDB3 * 0.925)) && (pwrDB1 >= (pwrDB4 * 1))) && ( (pwrDB1 <= (pwrDB2 * 0.7)) && (pwrDB1 <= (pwrDB3 * 0.68)) && (pwrDB1 <= (pwrDB4 * 0.8)) ) )
        zone = 2;
        compass = 'North North East';
        
    elseif (  ((pwrDB1 >= (pwrDB2 * 1)) && (pwrDB1 >= (pwrDB3 * 0.925)) && (pwrDB1 >= (pwrDB4 * 0.925))) && ( (pwrDB1 <= (pwrDB2 * 0.8)) && (pwrDB1 <= (pwrDB3 * 0.68)) && (pwrDB1 <= (pwrDB4 * 0.7)) ) )
        zone = 3;
        compass = 'East North West';
        
    else
        compass = 'North';
    end
           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
elseif ( (pwrDB2 >= pwrDB1) && (pwrDB2 >= pwrDB3) && (pwrDB2 >= pwrDB4) )
    
    if ( ( (pwrDB2 >= (pwrDB3 * 0.7)) && (pwrDB2 >= (pwrDB4 * 0.68)) && (pwrDB2 >= (pwrDB1 * 0.8)) ) || ( (pwrDB2 >= (pwrDB3 * 0.8)) && (pwrDB2 >= (pwrDB4 * 0.68)) && (pwrDB2 >= (pwrDB1 * 0.7)) ) )
        zone = 1;
        compass = 'East';
        
    elseif ( ((pwrDB2 >= (pwrDB3 * 0.925)) && (pwrDB2 >= (pwrDB4 * 0.925)) && (pwrDB2 >= (pwrDB1 * 1))) && ( (pwrDB2 <= (pwrDB3 * 0.7)) && (pwrDB2 <= (pwrDB4 * 0.68)) && (pwrDB2 <= (pwrDB1 * 0.8)) ) )
        zone = 2;
        compass = 'East North East';
        
    elseif (  ((pwrDB2 >= (pwrDB3 * 1)) && (pwrDB2 >= (pwrDB4 * 0.925)) && (pwrDB2 >= (pwrDB1 * 0.925))) && ( (pwrDB2 <= (pwrDB3 * 0.8)) && (pwrDB2 <= (pwrDB4 * 0.68)) && (pwrDB2 <= (pwrDB1 * 0.7)) ) )
        zone = 3;
        compass = 'East South East';
        
    else
        compass = 'East';
    end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
% elseif ( (pwrDB1 >= (pwrDB2 * 0.941)) && (pwrDB1 >= (pwrDB3 * 0.75)) && (pwrDB1 >= (pwrDB4 * 0.941)) )
%     zone = 4;
%     compass = 'South East';    
% elseif ( (pwrDB1 >= (pwrDB2 * 0.941)) && (pwrDB1 >= (pwrDB3 * 0.75)) && (pwrDB1 >= (pwrDB4 * 0.941)) )
%     zone = 5; 
%     compass = 'South';
% elseif ( (pwrDB1 >= (pwrDB2 * 0.941)) && (pwrDB1 >= (pwrDB3 * 0.75)) && (pwrDB1 >= (pwrDB4 * 0.941)) )
%     zone = 6;
%     compass = 'South West';
% elseif ( (pwrDB1 >= (pwrDB2 * 0.941)) && (pwrDB1 >= (pwrDB3 * 0.75)) && (pwrDB1 >= (pwrDB4 * 0.941)) )
%     zone = 7;
%     compass = 'West';
% elseif 
%     zone = 8;
%     compass = 'North West';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

display('compass')

end