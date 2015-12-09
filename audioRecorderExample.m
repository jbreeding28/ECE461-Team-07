%% 2014a simple detector
WINDOW_SIZE = 1024;
NUM_CHANNELS = 2;
har = dsp.AudioRecorder('NumChannels',NUM_CHANNELS,'SamplesPerFrame',WINDOW_SIZE);
har.ChannelMappingSource = 'Property';
har.DeviceName = 'Default';
% har.DeviceName = 'ASIO4ALL v2';
hmfw = dsp.AudioFileWriter('myspeech.wav','FileFormat','WAV');
disp('Speak into microphone now');

%this is me
% looks like there's about a second and a half overhead here i.e. the
% recordings are consistantly about 1.5 seconds too short I'm noticing that
% it switches between two exact numbers of samples every time I run it...
% weird

tic;

% h = figure(1);
% set(h,'Visible','on');
% audioData1 = zeros(1024,1);
% plot(audioData1)
% set(gca,'Visible','on')
while toc < 5
    singleFrame = step(har);
    
    for chanNum = 1:NUM_CHANNELS
        window = singleFrame(:,chanNum);
        X = abs(fft(window));
        % if there are any peaks above 0.3 in a limited range of the
        % spectrum, let the user know.
        if(max(X(25:WINDOW_SIZE-25)>0.3)==1)
            disp(['something detected on channel ' num2str(chanNum)]);
        end
    end
    % to save audio to file:
    % audioBlock = step(hmfw, step(har));
    % fft(audioBlock(:,1))
    % to save single frames of audio to a workspace array:
%     plot(audioData1(:,1))

%     spectrogram(audioData1(:,1))
end

release(har);
release(hmfw);
disp('Recording complete');

%% 2014a recorder
WINDOW_SIZE = 1024;
NUM_CHANNELS = 2;
har = dsp.AudioRecorder('NumChannels',NUM_CHANNELS,'SamplesPerFrame',WINDOW_SIZE);
har.ChannelMappingSource = 'Property';
har.DeviceName = 'ASIO4ALL v2';
hmfw = dsp.AudioFileWriter('myspeech.wav','FileFormat','WAV');
disp('Speak into microphone now');

tic;
while toc < 5

    % to save audio to file:
    step(hmfw, step(har));

end

release(har);
release(hmfw);
disp('Recording complete');

%% % 2015b example 
% % AR = dsp.AudioRecorder('OutputNumOverrunSamples',true);
% AR = dsp.AudioRecorder();
% 
% AFW = dsp.AudioFileWriter('myspeech.wav','FileFormat', 'WAV');
% disp('Speak into microphone now');
% tic;
% while toc < 10,
%   [audioIn] = step(AR);
%   step(AFW,audioIn);
% %   if nOverrun > 0
% %     fprintf('Audio recorder queue was overrun by %d samples\n'...
% %         ,nOverrun);
% %   end
% end
% release(AR);
% release(AFW);
% disp('Recording complete');