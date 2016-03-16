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
            zonecount(5)=zonecount(9)+1;
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
    im=(zonecount(1)*N+zonecount(2)*NW + ...
        zonecount(3)*W + zonecount(4)*SW + zonecount(5)*S + ...
        zonecount(6)*SE + zonecount(7)*E + zonecount(8)*NE)./len;
    im=imsubtract(background,im);
    textpos=[327 180; 185 180; 185 322; 327 322];
    text={amplitudes(1),amplitudes(2),amplitudes(3),amplitudes(4)};
    boxcolor={'white','white','white','white'};
    im=insertText(background,textpos,text,'FontSize',12,'BoxColor',...
        boxcolor,'BoxOpacity',0);
end
imshow(im);
end