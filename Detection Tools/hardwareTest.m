clear
% hardware test
audioDevices = audiodevinfo;
har = dsp.AudioRecorder('SamplesPerFrame',2048,'SampleRate',44100, ...
    'DeviceName','Line In (Scarlett 18i8 USB)','NumChannels',4);
tic;
while toc < 5
    testAudio = step(har);
    plot(testAudio)
    drawnow
end