function [aveSpectrum] = backgroundSpectrum(duration, Fs, specWindow, ...
    specOverlap)
    % BACKGROUNDSPECTRUM determine the average spectrum to
    FILE_NAME = 'background.wav';

    audioRecorder = dsp.AudioRecorder('NumChannels',1,'SampleRate',Fs);
    hmfw = dsp.AudioFileWriter(FILE_NAME,'FileFormat','WAV');
    
    tic;
    while toc < duration
        
        % save audio to file:
        step(hmfw, step(audioRecorder));
        
    end

    S = spectrogram(audioread(FILE_NAME,Fs),specWindow,specOverlap);
    % BE SURE THAT THIS IS THE SAME THING USED IN THE MAIN DETECTION LOOP
    % smooth things out in frequency (averaging filter with length of 4)
    for i = 1:size(S,2)
        S(:,i) = filter2(1/4*ones(4,1), abs(S(:,i)));
    end
    aveSpectrum = mean(abs(S),2);
    
    % CONSIDER ADDING A std deviation tool to warn user when the
    % environment isnt very stationary
end
    