classdef Detector < handle
    %DETECTOR A detector object
    
    properties (SetAccess = private)
        % c should be a struct that holds essential constants for detector
        c;
        audioRecorder;
        bufferedAudio;
        F_AXIS;
        % FRAMES_HELD is the number of frames held per channel
        FRAMES_HELD;
        previousSpectrum;
        currentEnergy;
        currentFlux;
        currentDroneAmplitude;
        autoCorrelator;
        currentf0;
    end
    
    methods
         
        function D = Detector(configSettings)
            if(nargin>0)
                D.c = configSettings.constants;
                D.F_AXIS = linspace(0,D.c.Fs/2,D.c.WINDOW_SIZE/2+1);
                D.FRAMES_HELD = ceil(D.c.TIME_TO_SAVE*D.c.Fs/D.c.FRAME_SIZE);
                D.bufferedAudio = zeros(D.FRAMES_HELD*D.c.FRAME_SIZE,1);
                D.previousSpectrum = zeros(D.c.WINDOW_SIZE/2+1,1);
                D.autoCorrelator = dsp.Autocorrelator(...
                    'MaximumLagSource','Property','MaximumLag',...
                    floor(1/150*D.c.Fs));
                D.currentDroneAmplitude = 0;
            end
        end
        
        function [decision] = step(D,singleAudioFrame)
        %STEP this function spits out a decision
        %   This method will be take audio one frame at a time and build up
        %   a colection of frames in the 'bufferedAudio' vector. It uses
        %   the data in the 'bufferedAudio' vector to make decisions on
        %   what kind of signal is in the audio. This is the primary method
        %   of the Detector class, and the only one that should be called
        %   publicly.
        
            % step the buffer
            D.bufferedAudio = [singleAudioFrame; ...
                D.bufferedAudio(1:((D.FRAMES_HELD-1)*D.c.FRAME_SIZE))];
            
            % spectrogram on the buffered audio
            spectrum = D.spectro();
            
            % set (0-150Hz) to zero note that this calculation is here to
            % show work. To optimize the code, replace with a constant
            binsize_Hz = (D.c.Fs/2)/(D.c.WINDOW_SIZE/2+1);
            spectrum(1:ceil(150/binsize_Hz)) = 0;
            
            % feature calculation
            D.currentEnergy = D.spectralEnergy(spectrum);
            D.currentFlux = D.spectralFlux(spectrum);
            D.currentf0 = D.periodicity();
            
            % decision
            decision = D.makeDecision(D.currentEnergy,D.currentFlux,...
                D.currentf0,spectrum);
            
            D.previousSpectrum = spectrum;
            
        end
        
        function spectrum = spectro(D)
        %SPECTRO calculates the spectrogram, smooths, then extracts a slice
        
            S = spectrogram(D.bufferedAudio,D.c.WINDOW_SIZE, ...
                D.c.SPECTROGRAM_OVERLAP);
            
            % apply a smoothing filter in time
            S_smooth = filter2(1/D.c.TIME_SMOOTHING_LENGTH* ...
                ones(1,D.c.TIME_SMOOTHING_LENGTH),abs(S));
            
            % extract a slice of the spectrogram
            spectrum = S_smooth(:,D.c.SLICE_NUMBER);
        end
        
        function flux = spectralFlux(D,spectrum1)
        %SPECTRALFLUX Calculates spectral flux between two spectra
            
            % normalize
            spectrum1 = spectrum1/sum(spectrum1);
            spectrum2 = D.previousSpectrum/sum(D.previousSpectrum+eps);

            flux = sum((spectrum2-spectrum1).^2);
        end
        
        function energy = spectralEnergy(D,spectrum)
        %SPECTRALENERGY calculates the energy in the spectrum
            energy = sum(spectrum.^2);
        end
        
        function output = makeDecision(D,energy,flux,f0,spectrum)
        %MAKEDECISION attempts to determine what kind of signal is present
        %   This method tries to determine which category the input signal
        %   fits into. The categories are (1) 'weak', (2) 'highly
        %   non-stationary', (3) 'non-drone oscillator', and (4) 'drone
        %   signal'. In the cases that the signal appear to be in class (3)
        %   or (4), the dronePresent(spectrum) method is called to
        %   distinguish between (3) and (4).
            
            D.currentDroneAmplitude = 0;
        
            if(energy < D.c.ENERGY_THRESHOLD)
                output = 'weak signal';
                return;
            end
            
            if(energy < flux*D.c.DECISION_SLOPE)
                output = 'highly non-stationary signal';
                return;
            end
            
            % if we reach here, an oscillator must be present
            
            if(f0 < 80 || f0 > 220)
                output = 'non-drone oscillator signal';
                return;
            end
            
            output = 'drone signal';
            amplitude = D.signalStrengthEstimate(f0,3,spectrum);
            D.currentDroneAmplitude = amplitude;
            
        end
        
        function amplitude = dronePresent(D,spectrum)
        %DRONEPRESENT determine if the signal coming in is from a drone
        %   This method should be used only if the input signal appears to
        %   be oscillatory.  An amplitude of zero will be returned if the
        %   signal does not appear to be a drone.
            
            % MINIMAL FEATURES SETUP:
            
            % use this down the road
            % [f0, harmonic] = D.periodicity();
            
            [f0, harmonic] = D.periodicity();
            
            if(~harmonic)
                amplitude = 0;
                return;
            end
            
            amplitude = D.signalStrengthEstimate(f0,3,spectrum);
            
            % LARGER FEATURE SET SETUP:
            
            % check to see if there is characteristic hi freq activity
%             if(D.hiFreqActivity(spectrum))
%                 amplitude = D.signalStrengthEstimate();
%                 return;
%             end
            
            currentWindow = D.bufferedAudio(1:D.c.WINDOW_SIZE);
            
            % otherwise, check for low frequency stuff
%             [harmRatio, f0] = feature_harmonic(currentWindow,D.c.Fs);
%             if(f0 > 80 && f0 < 225)
%                 if(feature_zcr(currentWindow)>0.1)
%                     if(D.spectralFlux(spectrum)<0.0003)
%                         amplitude = D.signalStrengthEstimate(f0,3,spectrum);
%                         return;
%                     end
%                 end
%                 amplitude = 0;
%                 return
%             else
%                 amplitude = 0;
%                 return;
%             end 

        end
        
        function energy = getEnergy(D)
            energy = D.currentEnergy;
        end
        
        function flux = getFlux(D)
            flux = D.currentFlux;
        end
        
        function f0 = getf0(D)
            f0 = D.currentf0;
        end
        
        function lastSpectrum = getPreviousSpectrum(D)
           lastSpectrum = D.previousSpectrum; 
        end
        
        function [f0, appearsDronePeriodic] = periodicity(D)
            % define a frequency range
            lo_f = 130;
            hi_f = 400;
            
            maximumLag = floor(1/lo_f*D.c.Fs);
            minimumLag = floor(1/hi_f*D.c.Fs);
            
            % compute autocorrelation
            correlationAudio = rotorPass(D.bufferedAudio(1:D.c.WINDOW_SIZE),D.c.Fs);
            autoCor = step(D.autoCorrelator,correlationAudio);
            
            autoCor(1:minimumLag) = 0;
            harmonicLag = find(autoCor == max(autoCor));
            f0 = (harmonicLag/D.c.Fs)^-1;
            appearsDronePeriodic = 0;
%              if(autoCor(harmonicLag) > ...
%                      3*mean(autoCor((minimumLag+1):length(autoCor))))
%                  appearsPeriodic = 1;
%              end
            if(f0 < 220 && f0 > 80)
                appearsDronePeriodic = 1;
            end
        end
        
        function amplitudeSum = signalStrengthEstimate(D,f0,numHarmonics,spectrum)
            amplitudeSum = 0;
            f0_binNum = floor(f0/(D.c.Fs/D.c.WINDOW_SIZE));
            for i = 1:numHarmonics
                for j = -2:2
                    amplitudeSum = amplitudeSum + spectrum(i*f0_binNum+j);
                end
            end
        end
        
        function amplitude = getDroneAmplitude(D)
            amplitude = D.currentDroneAmplitude;
        end
        
    end
    
end

