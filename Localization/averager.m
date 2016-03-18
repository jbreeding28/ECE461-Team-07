function [zone_val] = averager(sublocations)

len=sizeof(sublocations);
angles=[];
for i=1:len
    temp=sublocations(i);
    if temp ~= 0
        angles(end+1)=temp;
    end
end

theta_offset=-22.5;%offset in degrees
angles=angles.*45+theta_offset;

avg_angle = meanangle(angles);
if avg_angle < 0
    avg_angle = angle_val+360;
end
zone_val=(avg_angle-theta_offset)./45;
zone_val=round(zone_val);
% if zone_val == 0
%     zone_val=8;
% end

end