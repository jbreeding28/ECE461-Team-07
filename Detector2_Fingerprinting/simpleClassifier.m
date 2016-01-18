function [ audioClass ] = simpleClassifier(featureX, featureY, ...
    SIGNAL_ENERGY_CUTOFF, SLOPE_XY)

    if(featureY < SIGNAL_ENERGY_CUTOFF)
        audioClass = 'weak';
        return;
    else
        if(featureY < featureX*SLOPE_XY)
            audioClass = 'highly nonstationary';
            return;
        end
        audioClass = 'oscillator';
        return;
    end
    
end