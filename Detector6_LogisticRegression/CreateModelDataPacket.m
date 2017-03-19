function [FileName] = CreateModelDataPacket()

    dialogue = 'Please select all desired signal profiles to use for algorithm creation.';
    signalProfileNames = uigetfile('*.mat',dialogue, 'MultiSelect','on');
    
    numProfilesConfirmed = 0;
    numProfiles = 0;
    numProfileDialog = 'Did you select a single signal profile? Plese type yes or no.';
    while(numProfilesConfirmed == 0)
        confirmation = inputdlg(cast(numProfileDialog,'char')).';
        if(strcmp(confirmation,'yes'))
            numProfilesConfirmed = 1;
            numProfiles = 1;
        elseif(strcmp(confirmation,'no'))
            numProfilesConfirmed = 1;
            numProfiles = size(signalProfileNames,2);
        else
            numProfilesConfirmed = 0;    
        end
    end
    
    
    
    fileNameAssigned = 0;
    while(fileNameAssigned == 0)
        FileName = inputdlg('Please enter a FILE NAME for the Signal Profile.').';
        FileName = strcat({cast(FileName,'char')}, '.mat');       
         confirmation = inputdlg(strcat({'If '}, {cast(FileName,'char')}, {' is the desired FILE NAME, please type "yes". If it is incorrect, please type "no"'}));
         if(strcmp(confirmation,'yes'))
             fileNameAssigned = 1;
         end
    end
    numel(signalProfileNames)
    
    tableHeight = 0;
    rowsOfFeatures = zeros([numProfiles,1]);
    numPeaks = zeros([numProfiles,1]);
    sizeSTZCR = zeros([numProfiles,1]);
    sizeSTEnergy = zeros([numProfiles,1]);
    sizeSpecFlux = zeros([numProfiles,1]);
    
    if(numProfiles == 1)
            Profiles = SignalProfile(load(cast(signalProfileNames,'char')));
            rowsOfFeatures = Profiles.GetNumFeatureSets();
            FeatureData = Profiles.GetAllFeatureData();
            numPeaks = Profiles.GetNumSpecPeaks();
            sizeSTZCR = Profiles.GetSizeSTZCR();
            sizeSTEnergy = Profiles.GetSizeSTEnergy();
            sizeSpecFlux = Profiles.GetSizeSpecFlux();
    else
      for i = 1:numProfiles
            Profiles(i) = SignalProfile(load(cast(signalProfileNames(1,i),'char')));
            rowsOfFeatures(i) = Profiles(i).GetNumFeatureSets();
            tableHeight = tableHeight + rowsOfFeatures(i);
            FeatureData(i) = Profiles(i).GetAllFeatureData();
            numPeaks(i) = Profiles(i).GetNumSpecPeaks();
            sizeSTZCR(i) = Profiles(i).GetSizeSTZCR();
            sizeSTEnergy(i) = Profiles(i).GetSizeSTEnergy();
            sizeSpecFlux(i) = Profiles(i).GetSizeSpecFlux();
      end
    end
    tableHeight = sum(rowsOfFeatures);
%       dataPacket.Profiles = Profiles;
%       dataPacket.tableHeight = tableHeight;
%       dataPacket.FeatureData = FeatureData;
      
      maxNumPeaks = max(numPeaks);
      maxSizeSTZCR = max(sizeSTZCR);
      maxSizeSTEnergy = max(sizeSTEnergy);
      maxSizeSpecFlux = max(sizeSpecFlux);
      
      for i = 1:numProfiles
          if(numPeaks(i) < maxNumPeaks)
             FeatureData(i).SpectrumPeakFreqs = padarray(FeatureData(i).SpectrumPeakFreqs, [0,maxNumPeaks - numPeaks(i)] ,0,'post'); 
             FeatureData(i).SpectrumPeakValues = padarray(FeatureData(i).SpectrumPeakValues, [0,maxNumPeaks - numPeaks(i)],0,'post');
          end
          
          if(sizeSTZCR(i) < maxSizeSTZCR)
              FeatureData(i).STZCR = padarray(FeatureData(i).STZCR, [0,maxSizeSTZCR - sizeSTZCR(i)],0,'post');
          end
          
          if(sizeSTEnergy(i) < maxSizeSTEnergy)
              FeatureData(i).STEnergy = padarray(FeatureData(i).STEnergy, [0,maxNumPeaks - sizeSTEnergy(i)],0,'post');
          end
          
          if(sizeSpecFlux(i) < maxSizeSpecFlux)
              FeatureData(i).SpectrumFlux = padarray(FeatureData(i).SpectrumFlux, [0,maxNumPeaks - sizeSpecFlux(i)],0,'post');
          end
      end
      
        Name = cell([tableHeight,1]);
        ClassName = zeros([tableHeight,1]);
        SpectrumPeakFreqs = zeros([tableHeight,maxNumPeaks]);
        SpectrumPeakValues = zeros([tableHeight,maxNumPeaks]);
        SpectrumCentroid = zeros([tableHeight,1]);
        SpectrumCentroidValue = zeros([tableHeight,1]);
        SilencePercentage = zeros([tableHeight,1]);
        STZCR = zeros([tableHeight,maxSizeSTZCR]);
        AverageSTZCR = zeros([tableHeight,1]);
        ZCR = zeros([tableHeight,1]);
        STEnergy = zeros([tableHeight,maxSizeSTEnergy]);
        AverageSTEnergy = zeros([tableHeight,1]);
        Energy = zeros([tableHeight,1]);
        SpectrumFlux = zeros([tableHeight,maxSizeSpecFlux]);
        
     currentTableRow = 1;
     for i = 1:numProfiles
         SpectrumPeakFreqs((currentTableRow : currentTableRow + rowsOfFeatures(i) - 1),:) = FeatureData(i).SpectrumPeakFreqs;
         SpectrumPeakValues((currentTableRow : currentTableRow + rowsOfFeatures(i) - 1),:) = FeatureData(i).SpectrumPeakValues;
         SpectrumCentroid(currentTableRow : currentTableRow + rowsOfFeatures(i) - 1) = FeatureData(i).SpectrumCentroidFreq;
         SpectrumCentroidValue(currentTableRow : currentTableRow + rowsOfFeatures(i) - 1) = FeatureData(i).SpectrumCentroidValue;
         SilencePercentage(currentTableRow : currentTableRow + rowsOfFeatures(i) - 1) = FeatureData(i).SilencePercentage;
         STZCR((currentTableRow : currentTableRow + rowsOfFeatures(i) - 1),:) = FeatureData(i).STZCR;
         AverageSTZCR(currentTableRow : currentTableRow + rowsOfFeatures(i) - 1) = FeatureData(i).AverageZCR;
         ZCR(currentTableRow : currentTableRow + rowsOfFeatures(i) - 1) = FeatureData(i).ZCR;
         STEnergy((currentTableRow : currentTableRow + rowsOfFeatures(i) - 1),:) = FeatureData(i).STEnergy;
         AverageSTEnergy(currentTableRow : currentTableRow + rowsOfFeatures(i) - 1) = FeatureData(i).AverageEnergy;
         Energy(currentTableRow : currentTableRow + rowsOfFeatures(i) - 1) = FeatureData(i).Energy;
         SpectrumFlux((currentTableRow : currentTableRow + rowsOfFeatures(i) - 1),:) = FeatureData(i).SpectrumFlux;
         
         for j = 1:rowsOfFeatures(i)
             Name(currentTableRow) = {cast(FeatureData(i).Name,'char')};
             ClassName(currentTableRow) = FeatureData(i).IsDrone;
             currentTableRow = currentTableRow + 1;
         end
         
         
         
     end
     
%      dataPacket.Name = Name;
%      dataPacket.IsDrone = Class;
%      dataPacket.SpectrumPeakFreqs = SpectrumPeakFreqs;
%      dataPacket.SpectrumPeakValues = SpectrumPeakValues;
%      dataPacket.SpectrumCentroidFreq = SpectrumCentroidFreq;
%      dataPacket.SpectrumCentroidValue = SpectrumCentroidValue;
%      dataPacket.SilencePercentage = SilencePercentage;
%      dataPacket.STZCR = STZCR;
%      dataPacket.AverageZCR = AverageZCR;
%      dataPacket.ZCR = ZCR;
%      dataPacket.STEnergy = STEnergy;
%      dataPacket.AverageEnergy = AverageEnergy;
%      dataPacket.Energy = Energy;
%      dataPacket.SpectrumFlux = SpectrumFlux;
     DominantFrequency = SpectrumPeakFreqs(:,1);
     DominantFrequencyValue = SpectrumPeakValues(:,1);
     SecondHighestFrequency = SpectrumPeakFreqs(:,2);
     SecondHighestFrequencyValue = SpectrumPeakValues(:,2);
     ThirdHighestFrequency = SpectrumPeakFreqs(:,3);
     ThirdHighestFrequencyValue = SpectrumPeakValues(:,3);
     FourthHighestFrequency = SpectrumPeakFreqs(:,4);
     FourthHighestFrequencyValue = SpectrumPeakValues(:,4);
     FifthHighestFrequency = SpectrumPeakFreqs(:,5);
     FifthHighestFrequencyValue = SpectrumPeakValues(:,5);
          
          VariableNames = {'Name';
                           'ClassName';
                           'DominantFrequency';
                           'DominantFrequencyValue';
                           'SecondHighestFrequency';
                           'SecondHighestFrequencyValue';
                           'ThirdHighestFrequency';
                           'ThirdHighestFrequencyValue';
                           'FourthHighestFrequency';
                           'FourthHighestFrequencyValue';
                           'FifthHighestFrequency';
                           'FifthHighestFrequencyValue';
                           'SpectrumCentroid';
                           'SpectrumCentroidValue';
                           'SilencePercentage';
                           'STZCR';
                           'AverageZCR';
                           'ZCR';
                           'STEnergy';
                           'AverageEnergy';
                           'Energy';
                           'SpectrumFlux';
                           };
                       
                       
    save(cast(FileName,'char'), 'Name', 'ClassNumber',...
        'DominantFrequency', 'DominantFrequencyValue'...
        , 'SecondHighestFrequency', 'SecondHighestFrequencyValue',...
        'ThirdHighestFrequency', 'ThirdHighestFrequencyValue',...
        'FourthHighestFrequency', 'FourthHighestFrequencyValue',...
        'FifthHighestFrequency', 'FifthHighestFrequencyValue',...
        'SpectrumCentroidFreq', 'SpectrumCentroidValue',...
        'SilencePercentage',...
        'STZCR', 'AverageSTZCR', 'ZCR'...
        , 'STEnergy', 'AverageSTEnergy', 'Energy',...
        'SpectrumFlux',...
        'VariableNames');
%           
%           STZCR_d1 = STZCR(:,1);
%           STZCR_d2 = STZCR(:,2);
%           STZCR_d3 = STZCR(:,3);
%           STZCR_d4 = STZCR(:,4);
%           STZCR_d5 = STZCR(:,5);
%           STZCR_d6 = STZCR(:,6);
%           STZCR_d7 = STZCR(:,7);
%           STZCR_d8 = STZCR(:,8);
%           STZCR_d9 = STZCR(:,9);
%           STZCR_d20 = STZCR(:,10);
%           
%           STEnergy_d1 = STEnergy(:,1);
%           STEnergy_d2 = STEnergy(:,2);
%           STEnergy_d3 = STEnergy(:,3);
%           STEnergy_d4 = STEnergy(:,4);
%           STEnergy_d5 = STEnergy(:,5);
%           STEnergy_d6 = STEnergy(:,6);
%           STEnergy_d7 = STEnergy(:,7);
%           STEnergy_d8 = STEnergy(:,8);
%           STEnergy_d9 = STEnergy(:,9);
%           STEnergy_d10 = STEnergy(:,10);
%           
%           SpectrumFlux_d1 = SpectrumFlux(:,1);
%           SpectrumFlux_d2 = SpectrumFlux(:,2);
%           SpectrumFlux_d3 = SpectrumFlux(:,3);
%           SpectrumFlux_d4 = SpectrumFlux(:,4);
%           SpectrumFlux_d5 = SpectrumFlux(:,5);
%           SpectrumFlux_d6 = SpectrumFlux(:,6);
%           SpectrumFlux_d7 = SpectrumFlux(:,7);
%           SpectrumFlux_d8 = SpectrumFlux(:,8);
%           SpectrumFlux_d9 = SpectrumFlux(:,9);
%           SpectrumFlux_d10 = SpectrumFlux(:,10);     
end