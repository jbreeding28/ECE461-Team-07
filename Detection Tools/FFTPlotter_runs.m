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
FFTPlotter.plotContact8_spec('7 4-Audio, about 60 feet-1.wav');
figure
FFTPlotter.plotContact8_spec('7 5-Audio, about 60 feet-1.wav');
figure
FFTPlotter.plotContact8_spec('7 6-Audio, about 100 feet-1.wav');
figure

% A high altitude recording would probably be helpful

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
filenames = {'4 3-Audio-1, speech.wav',...
    '9 6-Audio, steady whistling.wav','4 3-Audio-1, background noise.wav'};
info = cell(1,length(filenames));
for i = 1:length(filenames)
    info{1,i} = FFTPlotter.plotContact8_spec(filenames{i});
    %print('-dbmp256','testPrint');
end
letters = {'A','B','C'};
for fileNum = 1:length(filenames)
    filedata = info{fileNum};
    xlswrite('Features.xls',filedata',letters(fileNum));
end
