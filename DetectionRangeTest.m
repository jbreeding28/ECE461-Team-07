load('C:\Users\breedijr\ECE461-Team-12-1617\Detector3\configSettings_4ChannelScarlett.mat')
load('C:\Users\breedijr\ECE461-Team-12-1617\Detector5_kNN\kNNConfig.mat')
DS = DroneSystem(configSettings,kNNStuff)

% setup the live plots
decisions = {'1'; '2'; '3'; '4'};
            
[hFig, hp, ha, hTextBox, hIm] = DS.figureSetup(decisions);
            
numPointsFeatureSpace = 100;
            
% features over time
energies = zeros(numPointsFeatureSpace,1);
fluxes = zeros(numPointsFeatureSpace,1);
zcrs = zeros(numPointsFeatureSpace,1);
f0s = zeros(numPointsFeatureSpace,1);
spectra = zeros(numPointsFeatureSpace, DS.c.WINDOW_SIZE/2+1);
            
amplitudes = zeros(1,1);
raw_locationBuffer = zeros(1,10);
avg_locations = zeros(1,10);
load('image_config.mat');
% eventually, put the below line in the if statement below
DS.localiz.configImViewer(hIm);
if(DS.c.NUM_CHANNELS==4)
    disp('Four input channels detected, localizer active')
    fourChannelMode = 4;
else
    disp([num2str(DS.c.NUM_CHANNELS) ...
    ' input channel(s) detected, 4 required for localize to go active'])
    fourChannelMode = 0;
end
           
% MAIN LOOP
while(1)
    try
        audioFrame = step(DS.audioRecorder);
        for i = 1:1
            decisions(i) = {DS.detectors(i).step(audioFrame(:,i))};
            amplitudes(i) = DS.detectors(i).getDroneAmplitude();
            stringOutput = [decisions{i}, ' E: ', ...
            num2str(DS.detectors(i).getEnergy()), ' F: ', ...
            num2str(DS.detectors(i).getFlux()), ' f0: ', ...
            num2str(DS.detectors(i).getf0()), ' zcr: ' ...
            num2str(DS.detectors(i).getZCR())];
            set(hTextBox(i),'String',stringOutput);
        end
        energies = [DS.detectors(1).getEnergy; ...
        energies(1:(numPointsFeatureSpace-1))];
        f0s = [DS.detectors(1).getf0;f0s(1:(numPointsFeatureSpace-1))];
        fluxes = [DS.detectors(1).getFlux; ...
        fluxes(1:(numPointsFeatureSpace-1))];
        zcrs = [DS.detectors(1).getZCR; ...
        zcrs(1:(numPointsFeatureSpace-1))];
        spectra = [DS.detectors(1).getPreviousSpectrum()'; ...
        spectra(1:(numPointsFeatureSpace-1),:)];
                
%                 set(hp(1),'YData',DS.detectors(1).getEnergy(),'XData',...
%                     DS.detectors(i).getFlux());
%                 set(hp(2),'YData',DS.detectors(1).getPreviousSpectrum());
                
        set(hp(1),'YData',f0s,'XData', fluxes,'ZData',zcrs);
        set(hp(2),'XData',DS.F_AXIS,'YData',...
        DS.detectors(1).getPreviousSpectrum());
        drawnow;
                
                % if there is a complete setup, run the localizer
        if(fourChannelMode)
            [location, A] = DS.localiz.direction(amplitudes(1),...
            amplitudes(2),amplitudes(3),amplitudes(4));
            raw_locationBuffer(2:end) = raw_locationBuffer...
            (1:end-1);
            raw_locationBuffer(1) = location;

            points_to_avg=5;
            avg_loc=DS.localiz.averager(raw_locationBuffer...
            (1:points_to_avg));
            avg_locations(2:end)=avg_locations(1:end-1);
            avg_locations(1)=avg_loc;

            DS.localiz.display2(avg_locations,A,bckgrnd,Czone,...
            NNEzone,ENEzone,ESEzone,SSEzone,SSWzone,WSWzone,...
            WNWzone,NNWzone,nodrone);
        end
    catch ME
    DS.localiz.historyToWorkspace();
    rethrow(ME);
    end
            
end
