%parpool(3)
clear;
parfor i=1:3
    c(:,i) = eig(rand(1000));
    x(i) = i;
end