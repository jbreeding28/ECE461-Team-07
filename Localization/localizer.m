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
                   location = 1;
                end
                if (I1 == 1 && I2 == 4) && (max1 == max2)
                   % fprintf('It is located E from the center\n');
                  
                elseif I1 == 1 && I2 == 4
                   % fprintf('It is located ENE from the center\n');
                   location = 2;
                end
                if (I1 == 2 && I2 == 1) && (max1 == max2)
                   % fprintf('It is located N from the center\n');
                   
                elseif I1 == 2 && I2 == 1
                   % fprintf('It is located NNW from the center\n');
                   location = 8;
                end
                if (I1 == 2 && I2 == 3) && (max1 == max2)
                   % fprintf('It is located W from the center\n');
                   
                elseif I1 == 2 && I2 == 3
                  %  fprintf('It is located WNW from the center\n');
                  location = 7;
                end
                if (I1 == 3 && I2 == 2) && (max1 == max2)
                  %  fprintf('It is located W from the center\n');
                  
                elseif I1 == 3 && I2 == 2
                  %  fprintf('It is located WSW from the center\n');
                  location = 6;
                end
                if (I1 == 3 && I2 == 4) && (max1 == max2)
                   % fprintf('It is located S from the center\n');
                   
                elseif I1 == 3 && I2 == 4
                   % fprintf('It is located SSW from the center\n');
                   location = 5;
                end
                if (I1 == 4 && I2 == 3) && (max1 == max2)
                   % fprintf('It is located S from the center\n');
                   
                elseif I1 == 4 && I2 == 3
                   % fprintf('It is located SSE from the center\n');
                   location = 4;
                end
                if (I1 == 4 && I2 == 1) && (max1 == max2)
                   % fprintf('It is located E from the center\n');
                   
                elseif I1 == 4 && I2 == 1
                   % fprintf('It is located ESE from the center\n');
                   location = 3;
                end
                
            end
            
            %fprintf('It is located %s from the center\n',string);
            %string = ['Q' num2str(I1)];
            %fprintf('Max = %f\nIndice: %i\n',max1,I1);
        end
    end   
end

