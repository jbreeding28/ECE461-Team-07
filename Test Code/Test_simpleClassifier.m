% simple cases
if(~strcmp(simpleClassifier(0,0,0.5,1),'weak'))
    error('simpleClassifier failed')
end

if(~strcmp(simpleClassifier(2,2,0.5,1),'oscillator'))
    error('simpleClassifier failed')
end

if(~strcmp(simpleClassifier(4,2,0.5,1),'highly nonstationary'))
    error('simpleClassifier failed')
end

disp('simpleClassifier passed')