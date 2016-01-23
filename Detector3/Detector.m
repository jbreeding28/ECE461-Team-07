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
    end
    
    methods
        % use this constructor if the detector is going to hold the
        % audiorecorder
%         function D = detector(configSettings)
%             D.c = configSettings.constants;
%             D.audioRecorder = dsp.AudioRecorder('SamplesPerFrame', ...
%             D.c.FRAME_SIZE, 'SampleRate',D.c.Fs,'DeviceName', ...
%             D.c.DEVICE_NAME,'NumChannels', D.c.NUM_CHANNELS);
%             D.F_AXIS = linspace(0,D.c.Fs/2,D.c.WINDOW_SIZE/2+1);
%             D.FRAMES_HELD = ceil(D.c.TIME_TO_SAVE*D.c.Fs/D.c.FRAME_SIZE);
%             D.bufferedAudio = zeros(D.FRAMES_HELD*D.c.FRAME_SIZE,NUM_CHANNELS);
%         end
         
        % use this constructor if the detector only prcesses one channel of
        % audio and the audiorecorder is held outside of this class
        function D = Detector(configSettings)
            if(nargin>0)
                D.c = configSettings.constants;
                D.F_AXIS = linspace(0,D.c.Fs/2,D.c.WINDOW_SIZE/2+1);
                D.FRAMES_HELD = ceil(D.c.TIME_TO_SAVE*D.c.Fs/D.c.FRAME_SIZE);
                D.bufferedAudio = zeros(D.FRAMES_HELD*D.c.FRAME_SIZE,1);
                D.previousSpectrum = zeros(D.c.WINDOW_SIZE/2+1,1);
            end
        end
        
        % this is to be used for testing purposes. Instead of using the
        % audiorecorder object to collect data, it allows signle frames of
        % audio to be sent in from other sources.
        function stepNonRT(singleAudioFrame)
            if(size(singleAudioFrame,1)~=detectorObj.c.FRAME_SIZE)
                error('The size of the input frame does not match the frame size specified in the configuration settings of this detector');
            end
            
            if(size(singleAudioFrame,2)~=detectorObj.c.NUM_CHANNELS)
                error('The number of channels in the input frame does not match the number of channels specified in the configuration settings of this detector');
            end
            
            step(singleAudioFrame);
            
        end
        
        function output = step(D,singleAudioFrame)
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
            
            spectrum = D.spectro();
            
            % feature calculation
            flux = D.spectralFlux(spectrum);
            energy = D.spectralEnergy(spectrum);
            
            % decision
            output = D.makeDecision(flux,energy,spectrum);
            
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
        
        
            if(energy < D.c.ENERGY_THRESHOLD)
                output = 'weak signal';
                return;
            end
            
            if(flux < energy*D.c.FLUXPERENERGY_MULTIPLER)
                output = 'highly non-stationary signal';
                return;
            end
            
            if(~D.dronePresent(spectrum))
                output = 'non-drone oscillating signal';
                return;
            end
            
            output = 'drone signal';
            
        end
        
        function dronePresentBoolean = dronePresent(spectrum)
        %DRONEPRESENT determine if the signal coming in is from a drone
        %   This method should be used only if the input signal appears to
        %   be oscillatory.
            dronePresentBoolean = 1;
        end
        
    end
    
end

