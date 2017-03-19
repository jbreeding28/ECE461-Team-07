classdef locatorGUI
    
    % LOCATORGUI maintains and updates a detection compass GUI.
    % Image data from .png files are loaded in. Based on detection and
    % direction finding, this class updates the image.
    
    properties (SetAccess = private)
        background;
        compass_generalN;
        compass_generalN_Alpha;
        compass_generalE;
        compass_generalE_Alpha;
        compass_generalS;
        compass_generalS_Alpha;
        compass_generalW;
        compass_generalW_Alpha;
        compassN;
        compassN_Alpha;
        compassE;
        compassE_Alpha;
        compassS;
        compassS_Alpha;
        compassW;
        compassW_Alpha;
        compassNNE;
        compassNNE_Alpha;
        compassENE;
        compassENE_Alpha;
        compassESE;
        compassESE_Alpha;
        compassSSE;
        compassSSE_Alpha;
        compassSSW;
        compassSSW_Alpha;
        compassWSW;
        compassWSW_Alpha;
        compassWNW;
        compassWNW_Alpha;
        compassNNW;
        compassNNW_Alpha;
        compassInside;
        compassInside_Alpha;
        droneDetected;
        droneDetected_Alpha;
        noDroneDetected;
        noDroneDetected_Alpha;
        headingN;
        headingN_Alpha;
        headingE;
        headingE_Alpha;
        headingS;
        headingS_Alpha;
        headingW;
        headingW_Alpha;
        headingNE;
        headingNE_Alpha;
        headingSE;
        headingSE_Alpha;
        headingSW;
        headingSW_Alpha;
        headingNW;
        headingNW_Alpha;
        headingNNE;
        headingNNE_Alpha;
        headingENE;
        headingENE_Alpha;
        headingESE;
        headingESE_Alpha;
        headingSSE;
        headingSSE_Alpha;
        headingSSW;
        headingSSW_Alpha;
        headingWSW;
        headingWSW_Alpha;
        headingWNW;
        headingWNW_Alpha;
        headingNNW;
        headingNNW_Alpha;
        headingNone;
        headingNone_Alpha;
    end
    
    methods
        function G = locatorGUI()
            % The image data and alpha data have to be extracted from all
            % of the .png files. These are all located in the GUI folder.
            % The specific images can be changed without changing the code,
            % as long as the general format is the same.
            [G.background, backgroundMap] = imread('background.png');
            [G.compassN, compassN_Map, G.compassN_Alpha] = imread('compass_N.png');
            [G.compassE, compassE_Map, G.compassE_Alpha] = imread('compass_E.png');
            [G.compassS, compassS_Map, G.compassS_Alpha] = imread('compass_S.png');
            [G.compassW, compassW_Map, G.compassW_Alpha] = imread('compass_W.png');
            [G.compass_generalN, compass_generalN_Map, G.compass_generalN_Alpha] = imread('compass_generalN.png');
            [G.compass_generalE, compass_generalE_Map, G.compass_generalE_Alpha] = imread('compass_generalE.png');
            [G.compass_generalS, compass_generalS_Map, G.compass_generalS_Alpha] = imread('compass_generalS.png');
            [G.compass_generalW, compass_generalW_Map, G.compass_generalW_Alpha] = imread('compass_generalW.png');
            [G.compassNNE, compassNNE_Map, G.compassNNE_Alpha] = imread('compass_NNE.png');
            [G.compassENE, compassENE_Map, G.compassENE_Alpha] = imread('compass_ENE.png');
            [G.compassESE, compassESE_Map, G.compassESE_Alpha] = imread('compass_ESE.png');
            [G.compassSSE, compassSSE_Map, G.compassSSE_Alpha] = imread('compass_SSE.png');
            [G.compassSSW, compassSSW_Map, G.compassSSW_Alpha] = imread('compass_SSW.png');
            [G.compassWSW, compassWSW_Map, G.compassWSW_Alpha] = imread('compass_WSW.png');
            [G.compassWNW, compassWNW_Map, G.compassWNW_Alpha] = imread('compass_WNW.png');
            [G.compassNNW, compassNNW_Map, G.compassNNW_Alpha] = imread('compass_NNW.png');
            [G.compassInside, compassInside_Map, G.compassInside_Alpha] = imread('compass_Inside.png');
            [G.droneDetected, droneDetected_Map, G.droneDetected_Alpha] = imread('drone_Detected.png');
            [G.noDroneDetected, noDroneDetected_Map, G.noDroneDetected_Alpha] = imread('no_Drone_Detected.png');
            [G.headingN, headingN_Map, G.headingN_Alpha] = imread('heading_N.png');
            [G.headingE, headingE_Map, G.headingE_Alpha] = imread('heading_E.png');
            [G.headingS, headingS_Map, G.headingS_Alpha] = imread('heading_S.png');
            [G.headingW, headingW_Map, G.headingW_Alpha] = imread('heading_W.png');
            [G.headingNE, headingNE_Map, G.headingNE_Alpha] = imread('heading_NE.png');
            [G.headingSE, headingSE_Map, G.headingSE_Alpha] = imread('heading_SE.png');
            [G.headingSW, headingSW_Map, G.headingSW_Alpha] = imread('heading_SW.png');
            [G.headingNW, headingNW_Map, G.headingNW_Alpha] = imread('heading_NW.png');
            [G.headingNNE, headingNNE_Map, G.headingNNE_Alpha] = imread('heading_NNE.png');
            [G.headingENE, headingENE_Map, G.headingENE_Alpha] = imread('heading_ENE.png');
            [G.headingESE, headingESE_Map, G.headingESE_Alpha] = imread('heading_ESE.png');
            [G.headingSSE, headingSSE_Map, G.headingSSE_Alpha] = imread('heading_SSE.png');
            [G.headingSSW, headingSSW_Map, G.headingSSW_Alpha] = imread('heading_SSW.png');
            [G.headingWSW, headingWSW_Map, G.headingWSW_Alpha] = imread('heading_WSW.png');
            [G.headingWNW, headingWNW_Map, G.headingWNW_Alpha] = imread('heading_WNW.png');
            [G.headingNNW, headingNNW_Map, G.headingNNW_Alpha] = imread('heading_NNW.png');
            [G.headingNone, headingNone_Map, G.headingNone_Alpha] = imread('heading_None.png');
        end
        
        % The image is initalized to the background with no heading and no
        % drone detected.
        function hLoc = initialize(G)
            hLoc = figure();
            imshow(G.background);
            hold on
            noDroneDetected_Image = imshow(G.noDroneDetected);
            set(noDroneDetected_Image,'AlphaData',G.noDroneDetected_Alpha);
            headingNone_Image = imshow(G.headingNone);
            set(headingNone_Image,'AlphaData',G.headingNone_Alpha);
            hold off
        end
        
        % This function returns an updated image. This function takes in
        % the last detected zones, current heading, and if a drone is
        % detected. The appropriate images are then overlaid on the
        % background.
        function hLocUpdated =  update(G,zoneHistory,heading,droneDetected,hLoc)
            % All the zones are checked to see if they're a member of the
            % history and where they're located.
            [zone0, zone0Location] = ismember(zoneHistory,0);
            [zone1, zone1Location] = ismember(zoneHistory,1);
            [zone2, zone2Location] = ismember(zoneHistory,2);
            [zone3, zone3Location] = ismember(zoneHistory,3);
            [zone4, zone4Location] = ismember(zoneHistory,4);
            [zone5, zone5Location] = ismember(zoneHistory,5);
            [zone6, zone6Location] = ismember(zoneHistory,6);
            [zone7, zone7Location] = ismember(zoneHistory,7);
            [zone8, zone8Location] = ismember(zoneHistory,8);
            [zone9, zone9Location] = ismember(zoneHistory,9);
            [zone10, zone10Location] = ismember(zoneHistory,10);
            [zone11, zone11Location] = ismember(zoneHistory,11);
            [zone12, zone12Location] = ismember(zoneHistory,12);
            [zone13, zone13Location] = ismember(zoneHistory,13);
            [zone14, zone14Location] = ismember(zoneHistory,14);
            [zone15, zone15Location] = ismember(zoneHistory,15);
            [zone16, zone16Location] = ismember(zoneHistory,16);
            hLocUpdated = figure(hLoc);
            imshow(G.background);
            hold on
            % If any of the zones are detected, they're overlaid onto the
            % background. Based on location, the alpha layer is modified to
            % make the image more opaque the more recent it is
            if(any(zone0))
                compassInside_Image = imshow(G.compassInside);
                set(compassInside_Image,'AlphaData',G.compassInside_Alpha .* max(find(zone0Location)));
            end
            if(any(zone1))
                compassN_Image = imshow(G.compassN);
                set(compassN_Image,'AlphaData',G.compassN_Alpha .* max(find(zone1Location)));
            end
            if(any(zone2))
                compassNNE_Image = imshow(G.compassNNE);
                set(compassNNE_Image,'AlphaData',G.compassNNE_Alpha .* max(find(zone2Location)));
            end
            if(any(zone3))
                compassENE_Image = imshow(G.compassENE);
                set(compassENE_Image,'AlphaData',G.compassENE_Alpha .* max(find(zone3Location)));
            end
            if(any(zone4))
                compassE_Image = imshow(G.compassE);
                set(compassE_Image,'AlphaData',G.compassE_Alpha .* max(find(zone4Location)));
            end
            if(any(zone5))
                compassESE_Image = imshow(G.compassESE);
                set(compassESE_Image,'AlphaData',G.compassESE_Alpha .* max(find(zone5Location)));
            end
            if(any(zone6))
                compassSSE_Image = imshow(G.compassSSE);
                set(compassSSE_Image,'AlphaData',G.compassSSE_Alpha .* max(find(zone6Location)));
            end
            if(any(zone7))
                compassS_Image = imshow(G.compassS);
                set(compassS_Image,'AlphaData',G.compassS_Alpha .* max(find(zone7Location)));
            end
            if(any(zone8))
                compassSSW_Image = imshow(G.compassSSW);
                set(compassSSW_Image,'AlphaData',G.compassSSW_Alpha .* max(find(zone8Location)));
            end
            if(any(zone9))
                compassWSW_Image = imshow(G.compassWSW);
                set(compassWSW_Image,'AlphaData',G.compassWSW_Alpha .* max(find(zone9Location)));
            end
            if(any(zone10))
                compassW_Image = imshow(G.compassW);
                set(compassW_Image,'AlphaData',G.compassW_Alpha .* max(find(zone10Location)));
            end
            if(any(zone11))
                compassWNW_Image = imshow(G.compassWNW);
                set(compassWNW_Image,'AlphaData',G.compassWNW_Alpha .* max(find(zone11Location)));
            end
            if(any(zone12))
                compassNNW_Image = imshow(G.compassNNW);
                set(compassNNW_Image,'AlphaData',G.compassNNW_Alpha .* max(find(zone12Location)));
            end
            if(any(zone13))
                compass_generalN_Image = imshow(G.compass_generalN);
                set(compass_generalN_Image,'AlphaData',G.compass_generalN_Alpha .* max(find(zone13Location)));
            end
            if(any(zone14))
                compass_generalE_Image = imshow(G.compass_generalE);
                set(compass_generalE_Image,'AlphaData',G.compass_generalE_Alpha .* max(find(zone14Location)));
            end
            if(any(zone15))
                compass_generalS_Image = imshow(G.compass_generalS);
                set(compass_generalS_Image,'AlphaData',G.compass_generalS_Alpha .* max(find(zone15Location)));
            end
            if(any(zone16))
                compass_generalW_Image = imshow(G.compass_generalW);
                set(compass_generalW_Image,'AlphaData',G.compass_generalW_Alpha .* max(find(zone16Location)));
            end
            if(droneDetected)
                droneDetected_Image = imshow(G.droneDetected);
                set(droneDetected_Image,'AlphaData',G.droneDetected_Alpha);
            else
                noDroneDetected_Image = imshow(G.noDroneDetected);
                set(noDroneDetected_Image,'AlphaData',G.noDroneDetected_Alpha);
            end
            if(strcmp(heading,'None'))
                heading_Image = imshow(G.headingNone);
                set(heading_Image,'AlphaData',G.headingNone_Alpha);
            elseif(strcmp(heading,'N'))
                heading_Image = imshow(G.headingN);
                set(heading_Image,'AlphaData',G.headingN_Alpha);
            elseif(strcmp(heading,'E'))
                heading_Image = imshow(G.headingE);
                set(heading_Image,'AlphaData',G.headingE_Alpha);
            elseif(strcmp(heading,'S'))
                heading_Image = imshow(G.headingS);
                set(heading_Image,'AlphaData',G.headingS_Alpha);
            elseif(strcmp(heading,'W'))
                heading_Image = imshow(G.headingW);
                set(heading_Image,'AlphaData',G.headingW_Alpha);
            elseif(strcmp(heading,'NE'))
                heading_Image = imshow(G.headingNE);
                set(heading_Image,'AlphaData',G.headingNE_Alpha);
            elseif(strcmp(heading,'SE'))
                heading_Image = imshow(G.headingSE);
                set(heading_Image,'AlphaData',G.headingSE_Alpha);
            elseif(strcmp(heading,'SW'))
                heading_Image = imshow(G.headingSW);
                set(heading_Image,'AlphaData',G.headingSW_Alpha);
            elseif(strcmp(heading,'NW'))
                heading_Image = imshow(G.headingNW);
                set(heading_Image,'AlphaData',G.headingNW_Alpha);
            elseif(strcmp(heading,'NNE'))
                heading_Image = imshow(G.headingNNE);
                set(heading_Image,'AlphaData',G.headingNNE_Alpha);
            elseif(strcmp(heading,'ENE'))
                heading_Image = imshow(G.headingENE);
                set(heading_Image,'AlphaData',G.headingENE_Alpha);
            elseif(strcmp(heading,'ESE'))
                heading_Image = imshow(G.headingESE);
                set(heading_Image,'AlphaData',G.headingESE_Alpha);
            elseif(strcmp(heading,'SSE'))
                heading_Image = imshow(G.headingSSE);
                set(heading_Image,'AlphaData',G.headingSSE_Alpha);
            elseif(strcmp(heading,'SSW'))
                heading_Image = imshow(G.headingSSW);
                set(heading_Image,'AlphaData',G.headingSSW_Alpha);
            elseif(strcmp(heading,'WSW'))
                heading_Image = imshow(G.headingWSW);
                set(heading_Image,'AlphaData',G.headingWSW_Alpha);
            elseif(strcmp(heading,'WNW'))
                heading_Image = imshow(G.headingWNW);
                set(heading_Image,'AlphaData',G.headingWNW_Alpha);
            elseif(strcmp(heading,'NNW'))
                heading_Image = imshow(G.headingNNW);
                set(heading_Image,'AlphaData',G.headingNNW_Alpha);
            end
            hold off
            drawnow;
        end
    end
end