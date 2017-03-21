% This funciton creates a Signal Profile based on audio data entered
% the user simply needs to enter waveform data at a minimum, but this
% funciton will operate much more quickly if the user also includes a
% sample frequency and the spectrunm data that accompanies the waveform(S).
% 
%Multiple waveforms and their corresponding spectrums can be enetered to be
%added into the new profile. Below is how the inputs work.
%
% Inputs:
%
%    waveform: this is a matrix of audio waveform data. Each column of the
%    matrix is expected to be one audio waveform. This allows the user to
%    enter multiple waveforms with each being its own column of the matrix.
%    Reminder: ENTER THE WAVEFORM DATA AS A COLUMN FOR THIS FUNCTION TO
%    OPERATE PROPERLY.
%
%   Fs: This is the sampling frequency of the waveforms, which is assumend
%   to be the same for each since this funciton will exist solely in the
%   system's main code and there is a constant samping frequency.
%
%   SpectrumData: This is a matrix of frequency spectrums. Each column of
%   the matrix is a single frequency spectrum, and that spectrum is
%   expected to be the frequency spectrum for the audio waveform in the
%   corresponding column of the waveform variable. For example,
%   SpectrumData(:,2) is the frequency spectrum for waveform(:,2)'s audio
%   data.
%   Reminder: ENTER THE SPECTRUM DATA AS A COLUMN FOR THIS FUNCTIUON TO
%   OPERATE PROPERLY. ALSO, THE SPECTRUM PRESENT IN A GIVEN COLUMN MUST BE
%   THE SPECTRUM FOR THAT NUMBER COLUMN IN waveform. 
%
%   waveform and SpectrumData MUST be the same size for this funciton to
%   work.
%
% Output:
%
%   ProfileFileName: This is the file name that the user inputs into the
%   code when prompted. It includes the .mat designation at the end. This
%   is returned so that whatever script that calls this funciton can
%   reference the new file that is created. 

function ProfileFileName = CreateSignalProfile(waveform, Fs, SpectrumData,samples)
numDataSets = size(waveform,2);
if(nargin < 4)
    samples = zeros([numDataSets,1]);
    for i = 1:numDataSets
        samples(i) = size(waveform,1);
    end
end
if(nargin < 3)
    SpectrumData = zeros(size(waveform));
    for (i = 1:numDataSets )
        SpectrumData(i,:) = abs(fftshift(fft(waveform(i,:))));
    end
end
if(nargin<2)
    Fs = 44100;
end
%Automatic Profile Generator

done = 0;
creationStep = 0;
fileName = '';
profileName = '';
TimesDetected = 1;



while(done==0)
    if(creationStep == 0)
        fileNameAssigned = 0;
        while(fileNameAssigned == 0)
                 fileName = inputdlg('Please enter a FILE NAME for the Signal Profile.');
%                  confirmation = inputdlg(strcat({'If '}, {cast(fileName,'char')}, {' is the desired FILE NAME, please type "yes". If it is incorrect, please type "no"'}));
%                  if(strcmp(confirmation,'yes'))
%                      fileNameAssigned = 1;
%                  end
                 
                 confirmation = menu(strcat({'Is '}, {cast(fileName,'char')}, {' the desired FILE NAME?'}),'Yes', 'No', 'Cancel Profile Creation');
                 switch(confirmation)
                     case 0
                         fileNameAssigned = 0;
                     case 1
                         fileNameAssigned = 1;
                     case 2
                         fileNameAssigned = 0;
                     case 3
                         return
                 end
         end
        profileNameAssigned = 0;
        while(profileNameAssigned == 0)
                 profileName = inputdlg('Please enter a SIGNAL PROFILE NAME.');
%                  confirmation = inputdlg(strcat({'If '}, {cast(profileName,'char')}, {' is the desired SIGNAL PROFILE NAME, please type "yes". If it is incorrect, please type "no"'}));
%                  if(strcmp(confirmation,'yes'))
%                      profileNameAssigned = 1;
%                  end
%                  
                 confirmation = menu(strcat({'Is '}, {cast(profileName,'char')}, {' the desired SIGNAL PROFILE NAME?'}),'Yes', 'No', 'Cancel Profile Creation')
                 switch(confirmation)
                     case 0
                        profileNameAssigned = 0;
                     case 1
                         profileNameAssigned = 1;
                     case 2
                         profileNameAssigned = 0;
                     case 3
                         return
                 end
        end
        profileTypeConfirmed = 0;
        while(profileTypeConfirmed == 0)
%             profileType = inputdlg('Please indicate the type of Signal Profile. Type "drone" if this is a drone profile. Otherwise type "noise" if this is an enviromental/ ambient noise profile');
%             confirmation = inputdlg(strcat({'You have selected '}, {cast(profileType,'char')}, {'. '}, {'Please type "yes" if this is corect, or "no" if not.'}));
%             if(strcmp(confirmation,'yes'))
%                 if(strcmp(profileType, 'drone'))
%                     isDrone = true;
%                 else
%                     isDrone = false;
%                 end
%                 profileTypeConfirmed = 1;
%             end
            
            profileType = menu('Is this profile for a Drone or a Noise?', 'Drone', 'Noise');
            switch(profileType)
                case 0
                   typeText = 'Window Closed';
                case 1
                   typeText = 'Drone';
                case 2
                   typeText = 'Noise';
            end
            
            if(strcmp(typeText, 'Drone'))
                isDrone = true;
            elseif(strcmp(typeText, 'Noise'))
                isDrone = false;
            end
            
            confirmation = menu(strcat({'You have selected '}, {cast(typeText,'char')}, {'. Is this correct?'}), 'Yes', 'No', 'Cancel Profile Creation');
            
            switch(confirmation)
                case 0
                    profileTypeConfirmed = 0;
                case 1
                    profileTypeConfirmed = 1;
                case 2
                    profileTypeConfirmed = 0;
                case 3
                    return
            end
        end
        
        AvgFreqSpec = mean(SpectrumData,2);
        FeatureData = ProfileDetectionFeatures(waveform, SpectrumData, Fs, samples);
        Name = profileName;
        IsDrone = isDrone;
        SpectrumPeakFreqs = FeatureData.specPeaksFreqs;
        SpectrumPeakValues = FeatureData.specPeaks;
        SpectrumCentroidFreq = FeatureData.Centroid;
        SpectrumCentroidValue = FeatureData.CentroidValue;
        SilencePercentage = FeatureData.silencePercentage;
        STZCR = FeatureData.STZCR;
        AverageZCR = FeatureData.AverageZCR;
        ZCR = FeatureData.ZCR;
        STEnergy = FeatureData.STEnergy;
        AverageEnergy = FeatureData.AverageEnergy;
        Energy = FeatureData.Energy;
        SpectrumFlux = FeatureData.SpectrumFlux;
    end
    %inputdlg('CODE NEAR END. TEXT ENTRY WILL TERMINATE PROGRAM.');
    ProfileFileName = strcat({cast(fileName,'char')}, {'.mat'});
    save(cast(ProfileFileName,'char'),'Name',...
        'AvgFreqSpec', 'SpectrumData', 'TimesDetected', 'IsDrone',...
        'SpectrumPeakFreqs', 'SpectrumPeakValues',...
        'SpectrumCentroidFreq', 'SpectrumCentroidValue',...
        'SilencePercentage',...
        'STZCR', 'AverageZCR', 'ZCR',...
        'STEnergy', 'AverageEnergy', 'Energy',...
        'SpectrumFlux');
    done = 1;
    
    
end 
end
