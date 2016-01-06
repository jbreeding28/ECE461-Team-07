function [ out ] = meanRemovalFilter1(input, filterLength)
%meanFilter1 A simple mean removal filter
%   at each point in the input signal, this filter subtracts off the
%   average of it's neighbors
    meanKernal = -1.*ones(1,filterLength)/(filterLength-1);
    meanKernal(ceil(filterLength/2)) = 1;
    if(length(input)==size(input,1))
         meanKernal = meanKernal';
    end
    
    out = filter2(meanKernal, input);

end