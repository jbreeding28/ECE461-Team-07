function [aveSpectrum] = backgroundSpectrum(duration, Fs, specWindow, ...
    specOverlap)
    % BACKGROUNDSPECTRUM determine the average spectrum
    % Record audio for a little bit, and use it to generate an average
    % spectrum; computed via spectrogram approach
    FILE_NAME = 'background.wav';
    disp('Background spectrum averaging started')
    audioRecorder = dsp.AudioRecorder('NumChannels',1,'SampleRate',Fs);
    audioWriter = dsp.AudioFileWriter(FILE_NAME,'FileFormat','WAV');
    
    tic;
    while toc < duration
        
        % save audio to file:
        step(audioWriter, step(audioRecorder));
        
    end

    S = spectrogram(audioread(FILE_NAME),specWindow,specOverlap);
    
    S_smooth = smoothSpectrogram(S);
    aveSpectrum = mean(S_smooth,2);
    disp('Background spectrum averaging finished')
    % CONSIDER ADDING A std deviation tool to warn user when the
    % environment isnt very stationary
end

function [aveSpectrum] = backgroundSpectrumAudio(pathToBackgroundAudio)
    % BACKGROUNDSPECTRUMAUDIO determine average spectrum using prerecorded
    % audio.
    S = spectrogram(audioread(pathToBackgroundAudio,Fs),specWindow,specOverlap);
    S_smooth = smoothSpectrogram(S);
    aveSpectrum = mean(S_smooth,2);
end