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
textpos=[15 230; 241 450; 453 230; 237 12];
text={'W','S','E','N'}; boxcolor={'white','white','white','white'};
bckgrnd = insertText(bckgrnd,textpos,text,'FontSize',30,'BoxColor',...
    boxcolor,'BoxOpacity',0);
imshow(bckgrnd);

%initialize different zones
Nzone=zeros(501,501,3); Ezone=Nzone; Szone=Nzone; Wzone=Nzone;
NEzone=Nzone; SEzone=Nzone; SWzone=Nzone; NWzone=Nzone;
% Nzone=image;  Ezone=image;  Szone=image;  Wzone=image;
% NEzone=image; SEzone=image; SWzone=image; NWzone=image;

%create the different zones
for i=1:501 %columns
    deltay=251-i;
    for j=1:501 %rows
        deltax=j-251;
        dist=sqrt(deltay.^2+deltax.^2);
        if dist < 200 %if the point is inside the circle
            theta=atan2(deltay,deltax);
            %classification based on theta
            if abs(theta) <= pi./8
                Ezone(i,j,1:3) = [1,1,0];
            elseif abs(theta) >= 7.*pi./8
                Wzone(i,j,1:3) = [1,1,0];
            elseif (theta > pi./8) && (theta < 3.*pi./8)
                NEzone(i,j,1:3) = [1,1,0];
            elseif (theta >= 3.*pi./8) && (theta <= 5.*pi./8)
                Nzone(i,j,1:3) = [1,1,0];
            elseif (theta > 5.*pi./8) && (theta < 7.*pi./8)
                NWzone(i,j,1:3) = [1,1,0];
            elseif (theta < -pi./8) && (theta > -3.*pi./8)
                SEzone(i,j,1:3) = [1,1,0];
            elseif (theta <= -3.*pi./8) && (theta <= -5.*pi./8)
                SWzone(i,j,1:3) = [1,1,0];
            else %if (theta < -5.*pi./8) && (theta > -7.*pi./8)
                Szone(i,j,1:3) = [1,1,0];
            end
        end
    end
end

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