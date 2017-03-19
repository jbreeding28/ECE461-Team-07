classdef SignalProfile < handle
    %SignalProfile contains the known signal information about a type of
    %drone. It can update existing information and present it to the user
    %by plotting and displaying said information.
    
    properties (SetAccess = private)
        Name %The name of the drone type/ noise environment containted in this profile
        AvgFreqSpec %this is the frequency spectrum when 10ft from a microphone
        TimesDetected %the number of times this type of drone has been positively detected.
        SpectrumData %this is a set of frequency spectrums that are associated 
                       %with the drone it's a nxm matrix where n is the number of spectrums and m is the data points in each spectrum
        IsDrone
        SpectrumPeakFreqs
        SpectrumPeakValues
        SpectrumCentroidFreq
        SpectrumCentroidValue
        SilencePercentage
        STZCR
        AverageZCR
        ZCR
        STEnergy
        AverageEnergy
        Energy
        SpectrumFlux
        
    end
    
    methods
        function SP = SignalProfile(profileData)
            if(nargin>0)
            SP.Name = profileData.Name;
            SP.AvgFreqSpec = profileData.AvgFreqSpec;
            SP.SpectrumData = profileData.SpectrumData;
            SP.TimesDetected = profileData.TimesDetected; %log of successfun drone hits
            SP.IsDrone = profileData.IsDrone;
            SP.SpectrumPeakFreqs = profileData.SpectrumPeakFreqs;
            SP.SpectrumPeakValues = profileData.SpectrumPeakValues;
            SP.SpectrumCentroidFreq = profileData.SpectrumCentroidFreq;
            SP.SpectrumCentroidValue = profileData.SpectrumCentroidValue;
            SP.SilencePercentage = profileData.SilencePercentage;
            SP.STZCR = profileData.STZCR;
            SP.AverageZCR = profileData.AverageZCR;
            SP.ZCR = profileData.ZCR;
            SP.STEnergy = profileData.STEnergy;
            SP.AverageEnergy = profileData.AverageEnergy;
            SP.Energy = profileData.Energy;
            SP.SpectrumFlux = profileData.SpectrumFlux;
            end
        end
                
        function displayData(SP)
            M = 22050;          
            
            freqAxis = linspace(-22.05,22.05,length(SP.avgFreqSpec));
            
            
            %peaks = abs(SP.avgFreqSpec(SP.specPeaks + M-1));
            
            F = figure('Position', [25 25 1200 1000]);
            %subplot(2,1,1 );
            P = plot(freqAxis, abs(SP.avgFreqSpec),'black');%, SP.specPeaks, peaks, 'red o');
            xlim([0 22050/1000]);
            set(gca, 'Position', [0.04 0.25 0.92 0.70]);
            namePlaceHolder = strrep(cast(SP.name,'char'),'_', ' ');
            title(namePlaceHolder);
            xlabel('frequency(kHz)');
            ylabel('Magnitude');
            legend('Average Frequency Spectrum', 'Frequency Spectrum Peaks');
            
            
            data = {'Times Detected', SP.timesDetected;'Spectrums Averaged', size(SP.spectrumData,1);'Number of Spectrum Peaks', length(SP.specPeaks)};
            position = [50 50 250 100];
            
            T = uitable(F, 'Data', data, 'Position', position, 'ColumnWidth', {175 25});      
            
            uicontrol('Style','text',...
        'Position',[400 50 700 100],...
        'String','Future detection features go here.');
           
%             uicontrol('Style', 'slider',...
%         'Min',1,'Max',100,'Value',50,...
%         'Position', [400 20 120 20],...
%         'Callback', {@changeYlim,ax}); 
        end
        
        function S = getAverageSpectrum(SP)
            S = SP.avgFreqSpec;           
        end
        
        function S = getSpectrumData(SP)
            S = SP.spectrumData;
        end
        
        function P = getSpectrumPeaks(SP)
            P = SP.specPeaks;
        end
        
        function D = getTimesDetected(SP)
            D = SP.timesDetected;
        end
        
        function incrementDetections(SP)
            SP.timesDetected = SP.timesDetected + 1;
        end
        
        function storeProfileData(SP)
            save([SP.name '.mat'],'name', 'claseFreqSpec', 'farFreqSpec', 'specPeaks', 'timesDetected');            
        end
        
        function changeYlim(hObj, event, ax)
            val = 101 - get(hObj,'Value');
            lim = val*22050/100;
            ax.Ylim([-lim lim]);
        end
        
        function number = GetNumFeatureSets(SP)
            number = length(SP.SilencePercentage);
        end
        
        function packet = GetAllFeatureData(SP)
             packet.Name = SP.Name;
             packet.IsDrone = SP.IsDrone;
             packet.SpectrumPeakFreqs = SP.SpectrumPeakFreqs;
             packet.SpectrumPeakValues = SP.SpectrumPeakValues;
             packet.SpectrumCentroidFreq = SP.SpectrumCentroidFreq;
             packet.SpectrumCentroidValue = SP.SpectrumCentroidValue;
             packet.SilencePercentage = SP.SilencePercentage;
             packet.STZCR = SP.STZCR;
             packet.AverageZCR = SP.AverageZCR;
             packet.ZCR = SP.ZCR;
             packet.STEnergy = SP.STEnergy;
             packet.AverageEnergy = SP.AverageEnergy;
             packet.Energy = SP.Energy;
             packet.SpectrumFlux = SP.SpectrumFlux;
        end
        
        function numPeaks = GetNumSpecPeaks(SP)
            numPeaks = numel(SP.SpectrumPeakValues(1,:));
        end
        
        function sizeSTZCR = GetSizeSTZCR(SP)
            sizeSTZCR = numel(SP.STZCR(1,:));
        end
        
        function sizeSTEnergy = GetSizeSTEnergy(SP)
            sizeSTEnergy = numel(SP.STEnergy(1,:));
        end
        
        function sizeSpecFlux = GetSizeSpecFlux(SP)
            sizeSpecFlux = numel(SP.SpectrumFlux(1,:));
        end
        
        
    end
        
        
    
end