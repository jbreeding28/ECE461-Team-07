clear
disp('Hardware test started')
% hardware test
audioDevices = audiodevinfo;
har = dsp.AudioRecorder('SamplesPerFrame',2048,'SampleRate',44100, ...
    'DeviceName','Focusrite USB 2.0 Audio Driver','NumChannels',4);
hFig = figure;
testAudio = step(har);
numberOfChannels = size(testAudio,2);
for i = 1:numberOfChannels
    subplot(numberOfChannels,1,i);
    h(i) = plot(testAudio(:,i));
    title(['channel #',num2str(i)]);
end

maxes = zeros(1,numberOfChannels);

tic;
while toc < 2.5
    testAudio = step(har);
    for i = 1:numberOfChannels
        set(h(i),'YData',testAudio(:,i));
        if(max(testAudio(:,i))>maxes(i))
            maxes(i) = max(testAudio(:,i));
        end
    end
    drawnow;
end

if(~isempty(find(maxes==0)))
    error(['hardware failed: No data on channel(s): ', num2str(find(maxes==0))])
end
disp('Hardware test passed, audio input on 4 channels using Focusrite ASIO drivers')
close(hFig)
clear
