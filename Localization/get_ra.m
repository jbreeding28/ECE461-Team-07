%module:   get_ra
%authors:  Lane Boyd
%date:     12/10/15
%function: this module determines estimated relative amplitudes at each
%          mic given the position of the sound source in space

%microphone locations
m2=[-10 10 0];
m1=[10 10 0];
m4=[10 -10 0];
m3=[-10 -10 0];
origin=[0 0 0];

%initialize grid
x=-20:0.5:20;
y=-20:0.5:20;
z=0:0.5:20;

%initialize and preallocate
index=0;
p=zeros(length(x)*length(y)*length(z),3);
%get all points
for i=1:length(x)
    for j=1:length(y)
        for k=1:length(z)
            index=index+1;
            p(index,:)=[x(i) y(j) z(k)];
        end
    end
end

%determine distances to different mics
index=0;
ra=zeros(length(x)*length(y)*length(z),4);
for i=1:length(x)*length(y)*length(z)
    index=index+1;
    pt=p(index,:);
    delta1=m1-pt; d1=norm(delta1);
    delta2=m2-pt; d2=norm(delta2);
    delta3=m3-pt; d3=norm(delta3);
    delta4=m4-pt; d4=norm(delta4);
    d=[d1 d2 d3 d4];    
    ra_pt=d.^(-2);%sound intensity proportional to inver square of distance
    ra_pt=ra_pt./max(ra_pt);%get on a scale from zero to one
    ra(index,:)=ra_pt;%add to array
end
%%%%%

%concatenate p and ra for analysis
rap=[p ra];
%now data interpretation
%analyze using vectors based on x and y coordainates

%initialize and preallocate
index=0;
avg=zeros(length(x)*length(y),6);
avg_index=0;
sd=zeros(length(x)*length(y),6);
sd_index=0;
temp=zeros(length(z),4);
temp_index=0;
%
for i=1:length(x)
    for j=1:length(y)
        for k=1:length(z)
            index=index+1;
            temp_index=temp_index+1;
            temp(temp_index,:)=rap(index,4:7);
        end
        avg_index=avg_index+1;
        sd_index=sd_index+1;
        avg(avg_index,:)=[x(i) y(j) mean(temp)];
        sd(sd_index,:)=[x(i) y(j) std(temp)];
        temp_index=0;
    end
end