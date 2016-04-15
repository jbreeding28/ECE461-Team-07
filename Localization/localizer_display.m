%This file creates the images used in the phosphor display. The images are
%saved as matrices (not in an image format) for performance. These matrices
%are stored in the file imae_config.mat. Note that the 'nodrone' matrix was
%not created by this file.

image=ones(501,501,3);%blank image used for display creation
M_circle=[251 251 200];%for system boundary
M_axes=[51 251 451 251; 251 51 251 451];%axes for quadrants
M_mics=[322 180; 180 180; 180 322; 322 322];%[origin,m1,m2,m3,m4]
% shapeInserter = vision.ShapeInserter('Shape','Circles');
% bckgrnd = step(shapeInserter, image, M_circle);
% shapeInserter = vision.ShapeInserter('Shape','Lines');
% bckgrnd = step(shapeInserter, bckgrnd, M_axes);
bckgrnd = insertShape(image,'Circle',M_circle,'Color','black');
bckgrnd = insertShape(bckgrnd,'Line',M_axes,'Color','black');
bckgrnd = insertMarker(bckgrnd,M_mics,'o','Color','black');
textpos=[15 230; 241 450; 453 230; 237 12];%add directions
text={'W','S','E','N'}; boxcolor={'white','white','white','white'};
bckgrnd = insertText(bckgrnd,textpos,text,'FontSize',30,'BoxColor',...
    boxcolor,'BoxOpacity',0);
%imwrite(bckgrnd,'bckgrnd.png');
%imshow(bckgrnd);

%initialize different zones
NNEzone=zeros(501,501,3); ENEzone=NNEzone; ESEzone=NNEzone; SSEzone=NNEzone;
SSWzone=NNEzone; WSWzone=NNEzone; WNWzone=NNEzone; NNWzone=NNEzone;
Czone=NNEzone;

%create the different zones
for i=1:501 %columns
    deltay=251-i;%vertical distance form center
    for j=1:501 %rows
        deltax=j-251;%horizontal distance from center
        dist=sqrt(deltay.^2+deltax.^2);%get hypotenuse
        if dist < 30 %if the pixel is within center of system
            Czone(i,j,1:3) = [1,1,0];
        elseif dist < 200 %if the pixel is within the system boundary
            theta=atan2(deltay,deltax);
            %classification based on theta
            if (theta>=0) && (theta < pi./4)
                ENEzone(i,j,1:3) = [1,1,0];
            elseif (theta >= pi./4) && (theta < pi./2)
                NNEzone(i,j,1:3) = [1,1,0];
            elseif (theta >= pi./2) && (theta < 3.*pi./4)
                NNWzone(i,j,1:3) = [1,1,0];
            elseif (theta >= 3.*pi./4) && (theta <= pi)
                WNWzone(i,j,1:3) = [1,1,0];
            elseif (theta <= 0) && (theta > -pi./4)
                ESEzone(i,j,1:3) = [1,1,0];
            elseif (theta <= -pi./4) && (theta > -pi./2)
                SSEzone(i,j,1:3) = [1,1,0];
            elseif (theta <= -pi./2) && (theta > -3.*pi./4)
                SSWzone(i,j,1:3) = [1,1,0];
            elseif (theta <= -3.*pi./4) && (theta > -pi)
                WSWzone(i,j,1:3) = [1,1,0];
            end
        end
    end
end
% imwrite(NNEzone,'NNEzone.png'); imwrite(ENEzone,'ENEzone.png');
% imwrite(NNWzone,'NNWzone.png'); imwrite(WNWzone,'WNWzone.png');
% imwrite(SSEzone,'SSEzone.png'); imwrite(ESEzone,'ESEzone.png');
% imwrite(SSWzone,'SSWzone.png'); imwrite(WSWzone,'WSWzone.png');

%consider generating background image in seperate file to save space
%consider generating zones in seperate file to save space
%above the center of the system identifier
%like phosphor display, save previous ten zones?
    %i'm thinking a 1x10 array to store zones w/ the oldest rotated out
    %numbers in the the array could range from 0 to 8
    %0 indicates no detection
    %1 is W, 2 is NW, 3 is N, 4 is NE, 5 is E, 6 is SE, 7 is S, 8 is SW
    %should find (or store) count of occurence of each number
    %can be stored in a 1x8 array that counts the total for each zone
    %zonecount=[W NW N NE E SE S SW]
    %then use below (in main loop after localizer)

% im=0.1.*(zonecount(1)*Wzone+zonecount(2)*NWzone + ...
%     zonecount(3)*Nzone + zonecount(4)*NEzone + zonecount(5)*Ezone + ...
%     zonecount(6)*SEzone + zonecount(7)*Szone + zonecount(8)*SWzone);
% im=imsubtract(bckgrnd,im);