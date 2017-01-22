function ProfileCreator()%spectrumData,Fs)
%Automatic Profile Generator
Y = audioread('Drone-Close.wav');
spectrumData = abs(fftshift(fft(Y(1,:))));
Fs = 44100;
clear all
close all
clc

done = 0;
creationStep = 0;
capsule.fileName = '';
capsule.profileName = '';
capsule.timesDetected = 1;



while(done==0)
    if(creationStep == 0)
        fileNameAssigned = 0;
        while(fileNameAssigned == 0)
                 capsule.fileName = inputdlg('Please enter a FILE NAME for the Signal Profile.');
                 confirmation = inputdlg(strcat({'If '}, {cast(capsule.fileName,'char')}, {' is the desired FILE NAME, please type "yes". If it is incorrect, please type "no"'}));
                 if(strcmp(confirmation,'yes'))
                     fileNameAssigned = 1;
                 end
         end
        profileNameAssigned = 0;
        while(profileNameAssigned == 0)
                 capsule.profileName = inputdlg('Please enter a SIGNAL PROFILE NAME.');
                 confirmation = inputdlg(strcat({'If '}, {cast(capsule.profileName,'char')}, {' is the desired SIGNAL PROFILE NAME, please type "yes". If it is incorrect, please type "no"'}));
                 if(strcmp(confirmation,'yes'))
                     profileNameAssigned = 1;
                 end
        end
        profileTypeConfirmed = 0;
        while(profileTypeConfirmed == 0)
            profileType = inputdlg('Please indicate the type of Signal Profile. Type "drone" if this is a drone profile. Otherwise type "noise" if this is an enviromental/ ambient noise profile');
            confirmation = inputdlg(strcat({'You have selected '}, {cast(profileType,'char')}, {'.'}, {'Please type "yes" if this is corect, or "no" if not.'}));
            if(strcmp(confirmation,'yes'))
                if(strcmp(profileType, 'drone'))
                    capsule.isDrone = true;
                else
                    capsule.isDrone = false;
                end
                profileTypeConfirmed = 1;
            end
        end
        
        capsule.avgFreqSpec = mean(1,spectrumData);
        avgFreqSpec = capsule.avgFreqSpec;
        FeatureData = GetDetectionFeatures(capsule.avgFreqSpec, Fs);
        name = capulse.profileName;
        isDrone = capsule.isDrone;
        fundamentalFreq = FeatureData.Fo;
        fundamentalFreqValue = FeatureData.FoValue;
        dominantFreq = FeatureData.DominantFreq;
        dominantFreqValue = FeatureData.DominantFreqValue;
        centroidFreq = FeatureData.Centroid;
        centroidFreqValue = FeatureData.CentroidValue;
    end
    inputdlg('CODE NEAR END. TEXT ENTRY WILL TERMINATE PROGRAM.');
    save(strcat({cast(capsule.fileName,'char')}, {'.mat'}),'name',...
        'avgFreqSpec', 'spectrumData', 'timesDetected', 'isDrone',...
        'fundamentalFreq', 'fundamentalFreqValue', 'dominantFreq',...
        'dominantFreqValue', 'centroidFreq', 'centroidFreqValue');
    done = 1;
end 
% 
% if(creationStep == 1)
% uicontrol('Style','text',...
%         'Position',[75 300 150 50],...
%         'String','Is this a drone profile?');
%     
% uicontrol('Style', 'pushbutton', 'String', 'Yes',...
%          'Position', [25 250 100 25],...
%          'Callback',{@DecideDrone,'yes'}); 
% 
% uicontrol('Style', 'pushbutton', 'String', 'No',...
%          'Position', [175 250 100 25],...
%          'Callback', {@DecideDrone,'no'}); 
%      if(capsule.isDrone == 1 || capsule.isDrone == 0)
%          creationStep = 2;
%      end
% end
% 
% if(creationStep == 2)
%     uicontrol('Style','text',...
%         'Position',[75 300 150 50],...
%         'String','Here');
% end
% 
% end
% 
% 
%     
% % uicontrol('Style', 'pushbutton', 'String', 'Display Iris',...
% %         'Position', [25 300 200  25],...
% %         'Callback', {@displayIris,drones}); 
%     
% 
% end
% 
% function createProfile(name, isDrone, Spectrums)
% 
% 
% timesDatected = 0;
% isDrone = 1;
% name = 'Iris_Anechoic';
% 
% Y = audioread('Drone-Anechoic.wav');
% D = audioinfo('Drone-Anechoic.wav');
% 
% X = fftshift(fft(Y));
% S = interp1(X,1:44100);
% 
% spectrumData = s;
% avgFreqSpec = mean(spectrumData,1);
% specPeaks = zeros(5);
% 
% save([name '.mat'], 'name', 'avgFreqSpec', 'specPeaks', 'timesDetected', 'spectrumData', 'isDrone');
% end 
% 
% function DecideDrone(hobj, event, answer)
%     if(strcmp(answer,'yes'))
%         capsule.isDrone = 1;
%     end
%     if(strcmp(answer,'no'))
%         capsule.isDrone = 0;
%     end
% end
end
