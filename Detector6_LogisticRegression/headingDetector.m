function direction = headingDetector(initialZone, finalZone)

% This heading detector takes in two zones from the direction finder and
% returns a string heading.
% The headings were all determined by hand.
switch initialZone
    % 0 is inside
    case 0
        switch finalZone
            case 0
                direction = 'None';
            case 1
                direction = 'N';
            case 2
                direction = 'NNE';
            case 3
                direction = 'ENE';
            case 4
                direction = 'E';
            case 5
                direction = 'ESE';
            case 6
                direction = 'SSE';
            case 7
                direction = 'S';
            case 8
                direction = 'SSW';
            case 9
                direction = 'WSW';
            case 10
                direction = 'W';
            case 11
                direction = 'WNW';
            case 12
                direction = 'NNW';
            case 13
                direction = 'N';
            case 14
                direction = 'E';
            case 15
                direction = 'S';
            case 16
                direction = 'W';
            otherwise
                direction = 'None';
        end
    % 1 is N
    case 1
        switch finalZone
            case 0
                direction = 'S';
            case 1
                direction = 'None';
            case 2
                direction = 'ESE';
            case 3
                direction = 'ESE';
            case 4
                direction = 'SE';
            case 5
                direction = 'SSE';
            case 6
                direction = 'SSE';
            case 7
                direction = 'S';
            case 8
                direction = 'SSW';
            case 9
                direction = 'SSW';
            case 10
                direction = 'SW';
            case 11
                direction = 'WSW';
            case 12
                direction = 'WSW';
            case 13
                direction = 'None';
            case 14
                direction = 'SE';
            case 15
                direction = 'S';
            case 16
                direction = 'SW';
            otherwise
                direction = 'None';
        end
    % 2 is NNE
    case 2
        switch finalZone
            case 0
                direction = 'SSW';
            case 1
                direction = 'WNW';
            case 2
                direction = 'None';
            case 3
                direction = 'ESE';
            case 4
                direction = 'SE';
            case 5
                direction = 'SSE';
            case 6
                direction = 'S';
            case 7
                direction = 'SSW';
            case 8
                direction = 'SSW';
            case 9
                direction = 'SW';
            case 10
                direction = 'WSW';
            case 11
                direction = 'WSW';
            case 12
                direction = 'W';
            case 13
                direction = 'WNW';
            case 14
                direction = 'SE';
            case 15
                direction = 'SSW';
            case 16
                direction = 'WSW';
            otherwise
                direction = 'None';
        end
    % 3 is ENE
    case 3
        switch finalZone
            case 0
                direction = 'WSW';
            case 1
                direction = 'NW';
            case 2
                direction = 'NNW';
            case 3
                direction = 'None';
            case 4
                direction = 'SSE';
            case 5
                direction = 'S';
            case 6
                direction = 'SSW';
            case 7
                direction = 'SSW';
            case 8
                direction = 'SW';
            case 9
                direction = 'WSW';
            case 10
                direction = 'WSW';
            case 11
                direction = 'W';
            case 12
                direction = 'WNW';
            case 13
                direction = 'NW';
            case 14
                direction = 'SSE';
            case 15
                direction = 'SSW';
            case 16
                direction = 'WSW';
            otherwise
                direction = 'None';
        end
    % 4 is E
    case 4
        switch finalZone
            case 0
                direction = 'W';
            case 1
                direction = 'NW';
            case 2
                direction = 'NNW';
            case 3
                direction = 'NNW';
            case 4
                direction = 'None';
            case 5
                direction = 'SSW';
            case 6
                direction = 'SSW';
            case 7
                direction = 'SW';
            case 8
                direction = 'WSW';
            case 9
                direction = 'WSW';
            case 10
                direction = 'W';
            case 11
                direction = 'WNW';
            case 12
                direction = 'WNW';
            case 13
                direction = 'NW';
            case 14
                direction = 'None';
            case 15
                direction = 'SW';
            case 16
                direction = 'W';
            otherwise
                direction = 'None';
        end
    % 5 is ESE
    case 5
        switch finalZone
            case 0
                direction = 'WNW';
            case 1
                direction = 'NNW';
            case 2
                direction = 'NNW';
            case 3
                direction = 'N';
            case 4
                direction = 'NNE';
            case 5
                direction = 'None';
            case 6
                direction = 'SSW';
            case 7
                direction = 'SW';
            case 8
                direction = 'WSW';
            case 9
                direction = 'W';
            case 10
                direction = 'WNW';
            case 11
                direction = 'WNW';
            case 12
                direction = 'NW';
            case 13
                direction = 'NNW';
            case 14
                direction = 'NNE';
            case 15
                direction = 'SW';
            case 16
                direction = 'WNW';
            otherwise
                direction = 'None';
        end
    % 6 is SSE
    case 6
        switch finalZone
            case 0
                direction = 'NNW';
            case 1
                direction = 'NNW';
            case 2
                direction = 'N';
            case 3
                direction = 'NNE';
            case 4
                direction = 'NE';
            case 5
                direction = 'ENE';
            case 6
                direction = 'None';
            case 7
                direction = 'WSW';
            case 8
                direction = 'W';
            case 9
                direction = 'WNW';
            case 10
                direction = 'WNW';
            case 11
                direction = 'NW';
            case 12
                direction = 'NNW';
            case 13
                direction = 'NNW';
            case 14
                direction = 'NE';
            case 15
                direction = 'WSW';
            case 16
                direction = 'WNW';
            otherwise
                direction = 'None';
        end
    % 7 is S
    case 7
        switch finalZone
            case 0
                direction = 'N';
            case 1
                direction = 'N';
            case 2
                direction = 'NNE';
            case 3
                direction = 'NNE';
            case 4
                direction = 'NE';
            case 5
                direction = 'ENE';
            case 6
                direction = 'ENE';
            case 7
                direction = 'None';
            case 8
                direction = 'WNW';
            case 9
                direction = 'WNW';
            case 10
                direction = 'NW';
            case 11
                direction = 'NNW';
            case 12
                direction = 'NNW';
            case 13
                direction = 'N';
            case 14
                direction = 'NE';
            case 15
                direction = 'None';
            case 16
                direction = 'NW';
            otherwise
                direction = 'None';
        end
    % 8 is SSW
    case 8
        switch finalZone
            case 0
                direction = 'NNE';
            case 1
                direction = 'NNE';
            case 2
                direction = 'NNE';
            case 3
                direction = 'NE';
            case 4
                direction = 'ENE';
            case 5
                direction = 'ENE';
            case 6
                direction = 'E';
            case 7
                direction = 'ESE';
            case 8
                direction = 'None';
            case 9
                direction = 'WNW';
            case 10
                direction = 'NW';
            case 11
                direction = 'NNW';
            case 12
                direction = 'N';
            case 13
                direction = 'NNE';
            case 14
                direction = 'ENE';
            case 15
                direction = 'ESE';
            case 16
                direction = 'NW';
            otherwise
                direction = 'None';
        end
    % 9 is WSW
    case 9
        switch finalZone
            case 0
                direction = 'ENE';
            case 1
                direction = 'NNE';
            case 2
                direction = 'NE';
            case 3
                direction = 'ENE';
            case 4
                direction = 'ENE';
            case 5
                direction = 'E';
            case 6
                direction = 'ESE';
            case 7
                direction = 'SE';
            case 8
                direction = 'SSE';
            case 9
                direction = 'None';
            case 10
                direction = 'NNW';
            case 11
                direction = 'N';
            case 12
                direction = 'NNE';
            case 13
                direction = 'NNE';
            case 14
                direction = 'ENE';
            case 15
                direction = 'SE';
            case 16
                direction = 'NNW';
            otherwise
                direction = 'None';
        end
    % 10 is W
    case 10
        switch finalZone
            case 0
                direction = 'E';
            case 1
                direction = 'NE';
            case 2
                direction = 'ENE';
            case 3
                direction = 'ENE';
            case 4
                direction = 'E';
            case 5
                direction = 'ESE';
            case 6
                direction = 'ESE';
            case 7
                direction = 'SE';
            case 8
                direction = 'SSE';
            case 9
                direction = 'SSE';
            case 10
                direction = 'None';
            case 11
                direction = 'NNE';
            case 12
                direction = 'NNE';
            case 13
                direction = 'NE';
            case 14
                direction = 'E';
            case 15
                direction = 'SE';
            case 16
                direction = 'None';
            otherwise
                direction = 'None';
        end
    % 11 is WNW
    case 11
        switch finalZone
            case 0
                direction = 'ESE';
            case 1
                direction = 'NE';
            case 2
                direction = 'ENE';
            case 3
                direction = 'E';
            case 4
                direction = 'ESE';
            case 5
                direction = 'ESE';
            case 6
                direction = 'SE';
            case 7
                direction = 'SSE';
            case 8
                direction = 'SSE';
            case 9
                direction = 'S';
            case 10
                direction = 'SSW';
            case 11
                direction = 'None';
            case 12
                direction = 'NNE';
            case 13
                direction = 'NE';
            case 14
                direction = 'ESE';
            case 15
                direction = 'SSE';
            case 16
                direction = 'SSW';
            otherwise
                direction = 'None';
        end
    % 12 is NNW
    case 12
        switch finalZone
            case 0
                direction = 'SSE';
            case 1
                direction = 'ENE';
            case 2
                direction = 'E';
            case 3
                direction = 'ESE';
            case 4
                direction = 'ESE';
            case 5
                direction = 'SE';
            case 6
                direction = 'SSE';
            case 7
                direction = 'SSE';
            case 8
                direction = 'S';
            case 9
                direction = 'SSW';
            case 10
                direction = 'SW';
            case 11
                direction = 'WSW';
            case 12
                direction = 'None';
            case 13
                direction = 'ENE';
            case 14
                direction = 'ESE';
            case 15
                direction = 'SSE';
            case 16
                direction = 'SW';
            otherwise
                direction = 'None';
        end
    % 13 is general N
    case 13
        switch finalZone
            case 0
                direction = 'S';
            case 1
                direction = 'None';
            case 2
                direction = 'ESE';
            case 3
                direction = 'ESE';
            case 4
                direction = 'SE';
            case 5
                direction = 'SSE';
            case 6
                direction = 'SSE';
            case 7
                direction = 'S';
            case 8
                direction = 'SSW';
            case 9
                direction = 'SSW';
            case 10
                direction = 'SW';
            case 11
                direction = 'WSW';
            case 12
                direction = 'WSW';
            case 13
                direction = 'None';
            case 14
                direction = 'SE';
            case 15
                direction = 'S';
            case 16
                direction = 'SW';
            otherwise
                direction = 'None';
        end
    % 14 is general E
    case 14
        switch finalZone
            case 0
                direction = 'W';
            case 1
                direction = 'NW';
            case 2
                direction = 'NNW';
            case 3
                direction = 'NNW';
            case 4
                direction = 'None';
            case 5
                direction = 'SSW';
            case 6
                direction = 'SSW';
            case 7
                direction = 'SW';
            case 8
                direction = 'WSW';
            case 9
                direction = 'WSW';
            case 10
                direction = 'W';
            case 11
                direction = 'WNW';
            case 12
                direction = 'WNW';
            case 13
                direction = 'NW';
            case 14
                direction = 'None';
            case 15
                direction = 'SW';
            case 16
                direction = 'W';
            otherwise
                direction = 'None';
        end
    % 15 is general S
    case 15
        switch finalZone
            case 0
                direction = 'N';
            case 1
                direction = 'N';
            case 2
                direction = 'NNE';
            case 3
                direction = 'NNE';
            case 4
                direction = 'NE';
            case 5
                direction = 'ENE';
            case 6
                direction = 'ENE';
            case 7
                direction = 'None';
            case 8
                direction = 'WNW';
            case 9
                direction = 'WNW';
            case 10
                direction = 'NW';
            case 11
                direction = 'NNW';
            case 12
                direction = 'NNW';
            case 13
                direction = 'N';
            case 14
                direction = 'NE';
            case 15
                direction = 'None';
            case 16
                direction = 'NW';
            otherwise
                direction = 'None';
        end
    % 16 is general W
    case 16
        switch finalZone
            case 0
                direction = 'E';
            case 1
                direction = 'NE';
            case 2
                direction = 'ENE';
            case 3
                direction = 'ENE';
            case 4
                direction = 'E';
            case 5
                direction = 'ESE';
            case 6
                direction = 'ESE';
            case 7
                direction = 'SE';
            case 8
                direction = 'SSE';
            case 9
                direction = 'SSE';
            case 10
                direction = 'None';
            case 11
                direction = 'NNE';
            case 12
                direction = 'NNE';
            case 13
                direction = 'NE';
            case 14
                direction = 'E';
            case 15
                direction = 'SE';
            case 16
                direction = 'None';
            otherwise
                direction = 'None';
        end
    otherwise
        direction = 'None';
end