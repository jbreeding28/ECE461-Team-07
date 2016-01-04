B = [0 0 0 0 1 5 1 0 0 0 0 0 0 3 6 8 8 6 5 10 3 0 0 0 0];
Bfilt = filter2([-1/4 -1/4 1 -1/4 -1/4],B);

functionOutput = meanRemovalFilter1(B,5);

if(min(size(Bfilt)==size(functionOutput))==0)
    error('meanRemovalFilter1 failed')
end
if(min(Bfilt==functionOutput)==0)
    error('meanRemovalFilter1 failed')
end

disp('meanRemovalFilter1 passed')