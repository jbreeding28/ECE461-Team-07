function [ zone, compass ] = location_v2(pwrs);
% Drone dB gains range from -89 dB (undetected) to -60 dB (Immediately next to the microphone)

% speed of sound = 340.29 m/s

% 3 sections per quadrant --> 12 sections

% mic "1" is at the north segment?

% 1.4833 (60 to 89) or 0.6742 (89 to 60)

pwrDB1 = pwrs(4); % mic 1 in dB
pwrDB2 = pwrs(3);
pwrDB3 = pwrs(2);  % mic's reversed???
pwrDB4 = pwrs(1);

if ( (pwrDB1 >= (pwrDB2 * 0.941)) && (pwrDB1 >= (pwrDB3 * 0.75)) && (pwrDB1 >= (pwrDB4 * 0.941)) )
    zone = 1;
    compass = 'North';

elseif ( ((pwrDB1 >= (pwrDB3 * 0.85)) && (pwrDB1 >= (pwrDB2 * 0.925)) && (pwrDB1 <= (pwrDB4 * 0.941))) || ((pwrDB4 >= (pwrDB2 * pwrDB2)) && (pwrDB4 >= (pwrDB3 * 0.925)) && (pwrDB4 <= (pwrDB1 * 0.941))) )
    zone = 2;
    compass = 'North East';
        
elseif ( (pwrDB4 >= (pwrDB3 * 0.941)) && (pwrDB4 >= (pwrDB2 * 0.75)) && (pwrDB4 >= (pwrDB1 * 0.941)) )
    zone = 3;
    compass = 'East';
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
else
    zone = 0;
    compass = 'Inside!'
end

display(compass)

end