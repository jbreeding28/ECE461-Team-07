%This function creates a data packet that is in the form of a .mat file in
%order for the main script of the system to utilise the detection feature
%data. The variable names to reference are included below in the
%explanatory text of this file below the inputs and outputs.
%
% Inputs: 
%
%   Signal Profiles: There are no actual inputs for this function, but it 
%   does require signal profiles to be present on the computer for the 
%   function to operate properly. They are selected by the user at runtime
%   and then the data inside of them is used to create the model data
%   packet.
%
% Outputs:
%
%   FileName: This is a string that is the file name of the .mat file that
%   is created so that the script that calls this function can load the
%   created file. 
%
%   Model Data Packet: This is a .mat file that is not a returned output of
%   the function, but it is an important output. This data file is saved to
%   the same folder that this file runs from. It is important to note that
%   this function  file should be present in the same exact file that the
%   calling code is in so that that function does not run into errors when
%   loading the data file.
%
% Notes:
%   
%   Function File Location: This function file should be in the same folder
%   as the MATLAB script that calls it. This mitigates possible errors when
%   attempting to reference the created data file.
%
%   Variable Names in the Data Packet: Below is a list of all of the
%   variable names that are packaged inside of the .mat file that is
%   created in this function. They can be referenced by loading the file
%   into a variable and then referencing them using the
%   packetVariable.VariableName format, or by simly loading the file into
%   the workspace and then calling the variable name itself.
%
%   Variable Name List:
%       Name - Name of the signal profile associated to the feature data
%       ClassNumber - Class number assigned to the feature data for
%                     classification
%       DominantFrequency - Highest frequency spectrum peak
%       DominantFrequencyValue - Frequency value of the highest
%                                frequency spectrum peak
%       SecondHighestFrequency - Second highest frequency spectrum peak
%       SecondHighestFrequencyValue - Frequency value of the second highest
%                                     frequency spectrum peak
%       ThirdHighestFrequency - Third highest frequency spectrum peak
%       ThirdHighestFrequencyValue - Frequency value of the third highest
%                                    frequency spectrum peak
%       FourthHighestFrequency - Fourth highest frequency spectrum peak
%       FourthHighestFrequencyValue - Frequency value of the fourth highest
%                                     frequency spectrum peak
%       FifthHighestFrequency - Fifth highest frequency spectrum peak
%       FifthHighestFrequencyValue - Frequency value of the fifth highest
%                                    frequency spectrum peak
%       SpectrumCentroid - Amplitude value of the spectrum centroid
%       SpectrumCentroidValue - Frequency value of the spectrum centroid
%       SilencePercentage - silence percentage of the waveform data
%       STZCR - short term zero crossing rate of the waveform
%       AverageZCR - average short time zero crossing rate of the waveform
%       ZCR - zero crossing rate of the whole waveform
%       STEnergy - Short term energy of the waveform
%       AverageEnergy - Average short term energy of the waveform
%       Energy - Total energy of the waveform
%       SpectrumFlux - Spectrum flux of the waveform
%
%       The term "The Waveform" references the audio waveform used to 
%       extract the feature data.
%   
function [FileName] = CreateModelDataPacket()

    %Prompt the user for which signal profiles to include in the data
    %packet
    dialogue = 'Please select all desired signal profiles to use for algorithm creation.';
    [signalProfileNames, profileFilePaths] = uigetfile('*.mat',dialogue, 'MultiSelect','on')
    
    numProfilesConfirmed = 0;
    numProfiles = 0;
    %Check to see if the user selected a single profile or multiple
    %profiles in order to avoid errors
    numProfileDialog = 'Did you select a single signal profile or multiple signal profiles?';
    while(numProfilesConfirmed == 0)       
        
        confirmation = menu(numProfileDialog, 'Single Profile', 'Multiple Profiles', 'Cancel Algorithm Creation');
        switch(confirmation)
            case 0
                numProfilesConfirmed = 0;
            case 1
                numProfilesConfirmed = 1;
                numProfiles = 1;
            case 2
                numProfilesConfirmed = 1;
                numProfiles = size(signalProfileNames,2);
            case 3
                return;
        end
    end
    
    
    
    %Get a file name from the user
    fileNameAssigned = 0;
    while(fileNameAssigned == 0)
        FileName = inputdlg('Please enter a FILE NAME for the Signal Profile.').';
        FileName = strcat({cast(FileName,'char')}, '.mat');       
         confirmation = menu(strcat({'Is '}, {cast(FileName,'char')}, {' is the desired FILE NAME?'}), 'Yes', 'No', 'Cancel Algorithm Creation');
        switch(confirmation)
            case 0
                fileNameAssigned = 0;
            case 1
                fileNameAssigned = 1;
            case 2
                fileNameAssigned = 0;
            case 3
                return;
        end
    end
    numel(signalProfileNames)
    
    %set up the matrices and arrays in order to stroe feature data
    tableHeight = 0;
    rowsOfFeatures = zeros([numProfiles,1]);
    numPeaks = zeros([numProfiles,1]);
    sizeSTZCR = zeros([numProfiles,1]);
    sizeSTEnergy = zeros([numProfiles,1]);
    sizeSpecFlux = zeros([numProfiles,1]);
    
    %mold the matrices and arrays for the single profile selected case
    if(numProfiles == 1)
            Profiles = SignalProfile(load(cast(strcat({cast(profileFilePaths,'char')},{cast(signalProfileNames,'char')}),'char')));
            rowsOfFeatures = Profiles.GetNumFeatureSets();
            FeatureData = Profiles.GetAllFeatureData();
            numPeaks = Profiles.GetNumSpecPeaks();
            sizeSTZCR = Profiles.GetSizeSTZCR();
            sizeSTEnergy = Profiles.GetSizeSTEnergy();
            sizeSpecFlux = Profiles.GetSizeSpecFlux();
    %mold the matrices and arrays for the multiple profile selected case     
    else
      for i = 1:numProfiles
            Profiles(i) = SignalProfile(load(cast(strcat({cast(profileFilePaths,'char')},{cast(signalProfileNames(1,i),'char')}),'char')));
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
      
      %Determine the maximum sizes of the possible feature data arrays and
      %matrices
      maxNumPeaks = max(numPeaks);
      maxSizeSTZCR = max(sizeSTZCR);
      maxSizeSTEnergy = max(sizeSTEnergy);
      maxSizeSpecFlux = max(sizeSpecFlux);
      
      %Pad the arrays of data in order to size them appropriately
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
      
      %Create variables that will be included in the .mat file
        Name = cell([tableHeight,1]);
        ClassNumber = zeros([tableHeight,1]);
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
        
     %Store the calculated feature data inside of the set up variables
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
             ClassNumber(currentTableRow) = FeatureData(i).IsDrone;
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

    %Store the spectrum peak data into five seperate variable pairs.
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
          
     %Set up variable names to save in the data packet
          VariableNames = {'Name';
                           'ClassNumber';
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
                       
    %Save the actual file
    save(cast(FileName,'char'), 'Name', 'ClassNumber',...
        'DominantFrequency', 'DominantFrequencyValue'...
        ,'SecondHighestFrequency', 'SecondHighestFrequencyValue',...
        'ThirdHighestFrequency', 'ThirdHighestFrequencyValue',...
        'FourthHighestFrequency', 'FourthHighestFrequencyValue',...
        'FifthHighestFrequency', 'FifthHighestFrequencyValue',...
        'SpectrumCentroid', 'SpectrumCentroidValue',...
        'SilencePercentage',...
        'STZCR', 'AverageSTZCR', 'ZCR'...
        , 'STEnergy', 'AverageSTEnergy', 'Energy',...
        'SpectrumFlux',...
        'VariableNames');

end