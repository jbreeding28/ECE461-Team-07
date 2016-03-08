function dronepresence = specificfreqdet(conditionedspectrum)
    Droneat4 = 0;
    Droneat17 = 0;
    Droneat19 = 0;
    %Moving forward calculate noise florr for specific range of frequencies
    %so we can pick up components we want. Bsically will split spectrum
    %into 3.5-10k and 10k plus, then run below script twice, searching for
    %peaks in each section based on that sections noise floor, this is due
    %to what essentially being noise in the lower range having a greater
    %value then the signal in the upper ranges
    ReducedSpectrumMiddle = spectrum(400:1000);
    ReducedSpectrumHigh = spectrum(1001:length(spectrum));
    AveMiddle = mean(ReducedSpectrumMiddle);
    AveHigh = mean(ReducedSpectrumHigh);  
    [peakLocMiddle, peakMagMiddle] = peakfinder(ReducedSpectrumMiddle, AveMiddle/4, 1.8*AveMiddle, 1, false, false);
    [peakLocHigh, peakMagHigh] = peakfinder(ReducedSpectrumHigh, AveHigh/6, 2.5*AveHigh, 1, false, false);
    for k = 1:length(peakLocMiddle)
        if(peakLocMiddle(k)<=40)
           Droneat4 = 1;
        end
    end
    for j = 1:length(peakLocHigh)
        if(peakLocHigh(j)>625 &&  peakLocHigh(j)<671)
           Droneat17 = 1;
        end
    end
    for l = 1:length(peakLocHigh)
        if(peakLocHigh(j)>765 && peakLocHigh(j)<811)
           Droneat19 = 1;
        end
    end
    DroneScore = Droneat4 + Droneat17 + Droneat19;
    if(DroneScore >= 3)
        detected = 1;
        disp('Drone detected');
    else
        detected = 0;
        disp('No Drone Detected');
    end
end