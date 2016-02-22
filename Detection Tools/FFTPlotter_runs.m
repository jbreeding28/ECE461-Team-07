%% Our recordings
% Focusrite setup
clear
FFTPlotter.plotContact8_spec('4 3-Audio-1, speech.wav');
figure
FFTPlotter.plotContact8_spec('9 6-Audio, steady whistling.wav');
figure
FFTPlotter.plotContact8_spec('4 3-Audio-1, background noise.wav');
figure
FFTPlotter.plotContact8_spec('4 3-Audio-1, footsteps.wav');
figure
FFTPlotter.plotContact8_spec('10 3-Audio-1,faint drone.wav');
figure
FFTPlotter.plotContact8_spec('0005 3-Audio, go cart.wav');
figure

% Beringer setup
FFTPlotter.plotContact8_spec('Birds and stuff.wav');
figure
FFTPlotter.plotContact8_spec('cheap drone, 50 feet mic pointed up-2.wav');
figure

%% From the internet
FFTPlotter.plotContact8_spec('6 Internet, 3DR Solo.wav');
figure
FFTPlotter.plotContact8_spec('Phantom 3 (#2)-1.wav');
figure
FFTPlotter.plotContact8_spec('0007 Internet, Probably Phantom 1.wav');
figure
FFTPlotter.plotContact8_spec('0011 Internet, Alt J.wav');
figure



%% Still need to get:
% a pure sine tone

%% Batch processing
filenames = {'9 6-Audio, steady whistling.wav'};
info = {};
for i = 1:length(filenames)
    FFTPlotter.plotContact8_spec(filenames{i});
    print('-dbmp256','testPrint');
end