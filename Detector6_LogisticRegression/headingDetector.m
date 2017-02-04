function direction = headingDetector(initialZone, finalZone)

switch initialZone
    % 1 is N
    case 1
        switch finalZone
            case 1
                direction = 'No movement';
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
                direction = 'S';
            otherwise
                direction = 'No movement';
        end
    % 2 is NNE
    case 2
        switch finalZone
            case 1
                direction = 'WNW';
            case 2
                direction = 'No movement';
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
                direction = 'SSW';
            otherwise
                direction = 'No movement';
        end
    % 3 is ENE
    case 3
        switch finalZone
            case 1
                direction = 'NW';
            case 2
                direction = 'NNW';
            case 3
                direction = 'No movement';
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
                direction = 'WSW';
            otherwise
                direction = 'No movement';
        end
    % 4 is E
    case 4
        switch finalZone
            case 1
                direction = 'NW';
            case 2
                direction = 'NNW';
            case 3
                direction = 'NNW';
            case 4
                direction = 'No movement';
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
                direction = 'W';
            otherwise
                direction = 'No movement';
        end
    % 5 is ESE
    case 5
        switch finalZone
            case 1
                direction = 'NNW';
            case 2
                direction = 'NNW';
            case 3
                direction = 'N';
            case 4
                direction = 'NNE';
            case 5
                direction = 'No movement';
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
                direction = 'WNW';
            otherwise
                direction = 'No movement';
        end
    % 6 is SSE
    case 6
        switch finalZone
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
                direction = 'No movement';
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
            otherwise
                direction = 'No movement';
        end
    % 7 is S
    case 7
        switch finalZone
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
                direction = 'No movement';
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
            otherwise
                direction = 'No movement';
        end
    % 8 is SSW
    case 8
        switch finalZone
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
                direction = 'No movement';
            case 9
                direction = 'ENE';
            case 10
                direction = 'NE';
            case 11
                direction = 'NNE';
            case 12
                direction = 'N';
            case 13
                direction = 'WSW';
            otherwise
                direction = 'No movement';
        end
    % 9 is WSW
    case 9
        switch finalZone
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
                direction = 'No movement';
            case 10
                direction = 'NNW';
            case 11
                direction = 'N';
            case 12
                direction = 'NNE';
            case 13
                direction = 'ENE';
            otherwise
                direction = 'No movement';
        end
    % 10 is W
    case 10
        switch finalZone
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
                direction = 'No movement';
            case 11
                direction = 'NNE';
            case 12
                direction = 'NNE';
            case 13
                direction = 'S';
            otherwise
                direction = 'No movement';
        end
    % 11 is WNW
    case 11
        switch finalZone
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
                direction = 'No movement';
            case 12
                direction = 'NNE';
            case 13
                direction = 'ESE';
            otherwise
                direction = 'No movement';
        end
    % 12 is NNW
    case 12
        switch finalZone
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
                direction = 'No movement';
            case 13
                direction = 'SSE';
            otherwise
                direction = 'No movement';
        end
    % 13 is inside
    case 13
        switch finalZone
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
                direction = 'No movement';
            otherwise
                direction = 'No movement';
        end
    otherwise
        direction = 'No movement';
end