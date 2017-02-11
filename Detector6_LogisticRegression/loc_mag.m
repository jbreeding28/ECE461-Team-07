function [ zone, compass ] = loc_mag(pwrs);

% Drone direction detection by pure magnitude of four microphones

% Written by Robert Vargo 2/7/17

% This code is meant for UAV ID and detection project team 12 of the
% academic year 2016/17

compass = 'inside?';
zone = 0;

pwr1 = pwrs(4); % mic 1 in dB
pwr2 = pwrs(3);
pwr3 = pwrs(2);  % mic's reversed???
pwr4 = pwrs(1);

ratio = 2;

if( (pwr1 > pwr2) && (pwr1 > pwr3) && (pwr1 > pwr4) )
    if( (pwr2 > pwr3) && (pwr2 > pwr4) )
        if( ((pwr3 + ratio) > pwr4 ) )
            compass = '15';
            zone = 15;
        elseif( (pwr4 > (pwr3 + ratio)) )
            compass = '16';
            zone = 16;
        end

    elseif( (pwr4 > pwr2) && (pwr4 > pwr3) )
        if( (pwr2 > (pwr3 + ratio)) )
            compass = '1';
            zone = 1;
        elseif( ((pwr3 + ratio) > pwr2) )
            zone = 2;
            compass = '2';
        end
    end
elseif( (pwr4 > pwr1) && (pwr4 > pwr2) && (pwr4 > pwr3) );
    if( (pwr1 > pwr2) && (pwr1 > pwr3) )
        if( (pwr2 + ratio) > pwr3 )
            zone = 3;
            compass = '3';
        elseif( pwr3 > (pwr2 + ratio) )
            zone = 4;
            compass = '4';
        end
    elseif( (pwr3 > pwr1) && (pwr3 > pwr2) )
        if( (pwr2 + ratio) > pwr1 )
            zone = 6;
            compass ='6';
        elseif( pwr1 > (pwr2 + ratio) )
            zone = 5;
            compass = '5';
        end
    end
end



display(compass)




end