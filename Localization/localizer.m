classdef Localizer
    %LOCALIZER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function L = Localizer()
        end
        function [location, A] = direction(L,A1,A2,A3,A4)
            %Input 4 amplitudes (representing the peak magnitude recieved at each mic)
            %  Output: Text describing the direction of the source
            A = [A1 A2 A3 A4];
            if (A1==0&&A2==0&&A3==0&&A4==0)
                %fprintf('No drone detected\n')
                location = 0;
                return;
            end
            [max1, I1] = max(A);
            A(I1) = [-50];
            [max2, I2] = max(A);
            A(I2) = [-50];
            [max3, I3] = max(A);
            A(I3) = [-50];
            [max4, I4] = max(A);
            A(I4) = [];
            if (((max2*.95 <= max1) && (max1 <= max2*1.05)) && ((max3*.95 <= max1) && (max1 <= max3*1.05)) && ((max4*.95 <= max1) && (max1 <= max4*1.05)))
               % fprintf('Source is located directly above in the center\n');
%             elseif (I1 == 1 && I2 == 3)
%                 fprintf('There are two sources in quadrant 1 and 3\n');
%             elseif (I1 == 2 && I2 == 4)
%                 fprintf('There are two sources in quadrant 2 and 4\n');
%             elseif (I1 == 3 && I2 == 1)
%                 fprintf('There are two sources in quadrant 1 and 3\n');
%             elseif (I1 == 4 && I2 == 2)
%                 fprintf('There are two sources in quadrant 2 and 4\n');
            else
                if (I1 == 1 && I2 == 2) && (max1 == max2)
                   % fprintf('It is located N from the center\n');
                   
                elseif I1 == 1 && I2 == 2
                   % fprintf('It is located NNE from the center\n');
                   location = 2;
                end
                if (I1 == 1 && I2 == 4) && (max1 == max2)
                   % fprintf('It is located E from the center\n');
                  
                elseif I1 == 1 && I2 == 4
                   % fprintf('It is located ENE from the center\n');
                   location = 1;
                end
                if (I1 == 2 && I2 == 1) && (max1 == max2)
                   % fprintf('It is located N from the center\n');
                   
                elseif I1 == 2 && I2 == 1
                   % fprintf('It is located NNW from the center\n');
                   location = 3;
                end
                if (I1 == 2 && I2 == 3) && (max1 == max2)
                   % fprintf('It is located W from the center\n');
                   
                elseif I1 == 2 && I2 == 3
                  %  fprintf('It is located WNW from the center\n');
                  location = 4;
                end
                if (I1 == 3 && I2 == 2) && (max1 == max2)
                  %  fprintf('It is located W from the center\n');
                  
                elseif I1 == 3 && I2 == 2
                  %  fprintf('It is located WSW from the center\n');
                  location = 5;
                end
                if (I1 == 3 && I2 == 4) && (max1 == max2)
                   % fprintf('It is located S from the center\n');
                   
                elseif I1 == 3 && I2 == 4
                   % fprintf('It is located SSW from the center\n');
                   location = 6;
                end
                if (I1 == 4 && I2 == 3) && (max1 == max2)
                   % fprintf('It is located S from the center\n');
                   
                elseif I1 == 4 && I2 == 3
                   % fprintf('It is located SSE from the center\n');
                   location = 7;
                end
                if (I1 == 4 && I2 == 1) && (max1 == max2)
                   % fprintf('It is located E from the center\n');
                   
                elseif I1 == 4 && I2 == 1
                   % fprintf('It is located ESE from the center\n');
                   location = 8;
                end
                
            end
            
            %fprintf('It is located %s from the center\n',string);
            %string = ['Q' num2str(I1)];
            %fprintf('Max = %f\nIndice: %i\n',max1,I1);
        end
        
        function [] = display2(locations,amplitudes,background,NNE,ENE,ESE,SSE,...
                SSW,WSW,WNW,NNW)
            zonecount=zeros(1,9);
            len=sizeof(locations);
            for i=1:len
                n=locations(i);
                switch n
                    case 0 %no drone
                        zonecount(9)=zonecount(9)+1;
                    case 1 %NNE
                        zonecount(1)=zonecount(1)+1;
                    case 2 %ENE
                        zonecount(2)=zonecount(2)+1;
                    case 3 %ESE
                        zonecount(3)=zonecount(3)+1;
                    case 4 %SSE
                        zonecount(4)=zonecount(4)+1;
                    case 5 %SSW
                        zonecount(5)=zonecount(5)+1;
                    case 6 %WSW
                        zonecount(6)=zonecount(6)+1;
                    case 7 %WNW
                        zonecount(7)=zonecount(7)+1;
                    case 8 %NNW
                        zonecount(8)=zonecount(8)+1;
                end
            end
            
            if zonecount(9) == len
                textpos=[100 180]; boxcolor={'white'};
                text={'NO DRONE DETECTED'}; textcolor={'red'};
                im=insertText(background,textpos,text,'FontSize',30,'BoxColor',...
                    boxcolor,'BoxOpacity',0,'TextColor',textcolor);
            else
                im=(zonecount(1).*NNE+zonecount(2).*ENE + ...
                    zonecount(3).*ESE + zonecount(4).*SSE + zonecount(5).*SSW + ...
                    zonecount(6).*WSW + zonecount(7).*WNW + zonecount(8).*NNW)./len;
                im=imsubtract(background,im);
                textpos=[327 180; 185 180; 185 322; 327 322];
                text={amplitudes(1),amplitudes(2),amplitudes(3),amplitudes(4)};
                boxcolor={'white','white','white','white'};
                im=insertText(background,textpos,text,'FontSize',12,'BoxColor',...
                    boxcolor,'BoxOpacity',0);
            end
            imshow(im);
        end
    end   
end

