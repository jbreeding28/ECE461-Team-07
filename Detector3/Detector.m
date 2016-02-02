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
    end
    
    methods
         
        function D = Detector(configSettings)
            if(nargin>0)
                D.c = configSettings.constants;
                D.F_AXIS = linspace(0,D.c.Fs/2,D.c.WINDOW_SIZE/2+1);
                D.FRAMES_HELD = ceil(D.c.TIME_TO_SAVE*D.c.Fs/D.c.FRAME_SIZE);
                D.bufferedAudio = zeros(D.FRAMES_HELD*D.c.FRAME_SIZE,1);
                D.previousSpectrum = zeros(D.c.WINDOW_SIZE/2+1,1);
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
            
            % set (0-150Hz) to zero
            % note that this calculation is here to show work done. To
            % optimize the code, replace with a constant
            binsize_Hz = (D.c.Fs/2)/(D.c.WINDOW_SIZE/2+1);
            spectrum(1:ceil(150/binsize_Hz)) = 0;
            
            % feature calculation
            D.currentEnergy = D.spectralEnergy(spectrum);
            D.currentFlux = D.spectralFlux(spectrum);
            
            % decision
            decision = D.makeDecision(D.currentFlux,D.currentEnergy,spectrum);
            
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
            if(1<0)
                disp(D.c.NUM_CHANNELS);
            end
        end
        
        function output = makeDecision(D,energy,flux,spectrum)
        %MAKEDECISION attempts to determine what kind of signal is present
        %   This method tries to determine which category the input signal
        %   fits into. The categories are (1) 'weak', (2) 'highly
        %   non-stationary', (3) 'non-drone oscillator', and (4) 'drone
        %   signal'. In the cases that the signal appear to be in class (3)
        %   or (4), the dronePresent(spectrum) method is called to
        %   distinguish between (3) and (4).
        
        output = ['E: ', num2str(energy), ' F: ', num2str(flux)];
        
            if(energy < D.c.ENERGY_THRESHOLD)
                output = [output, ' weak signal'];
                output = 'weak signal';
                return;
            end
            
            if(flux < energy*D.c.FLUXPERENERGY_MULTIPLER)
                output = [output, ' highly non-stationary signal'];
                output = 'highly non-stationary signal';
                return;
            end
            
            if(~D.dronePresent(spectrum))
                output = [output, ' non-drone oscillating signal'];
                output = 'non-drone oscillator signal';
                return;
            end
            
            output = [output ' drone signal'];
            output = 'drone signal';
            
        end
        
        function dronePresentBoolean = dronePresent(D,spectrum)
        %DRONEPRESENT determine if the signal coming in is from a drone
        %   This method should be used only if the input signal appears to
        %   be oscillatory.
            dronePresentBoolean = 1;
        end
        
        function energy = getEnergy(D)
            energy = D.currentEnergy;
        end
        
        function flux = getFlux(D)
            flux = D.currentFlux;
        end
        
        function lastSpectrum = getPreviousSpectrum(D)
           lastSpectrum = D.previousSpectrum; 
        end
        
    end
    
end

