clear
filenames_pos = {...
    '9 6-Audio, steady whistling.wav',...
    '10 3-Audio-1,faint drone.wav',...
    '7 4-Audio, about 60 feet-1.wav',...
    '7 5-Audio, about 60 feet-1.wav'...
    '7 6-Audio, about 100 feet-1.wav'};
filenames_neg = {...
    '4 3-Audio-1, speech.wav',...
    '0005 3-Audio, go cart.wav'};

features_pos = [0,0];
features_neg = [0,0];

for i = 1:length(filenames_pos)
    figure
    theseFeatures = FFTPlotter.plotContact8_kNN(filenames_pos{i});
    features_pos = [features_pos; theseFeatures];
end

features_pos = features_pos(2:length(features_pos),:);
    
for i = 1:length(filenames_neg)
    figure
    theseFeatures = FFTPlotter.plotContact8_kNN(filenames_neg{i});
    features_neg = [features_neg; theseFeatures];
end

features_neg = features_neg(2:length(features_neg),:);

plot(features_pos(:,1),features_pos(:,2),'x',...
    features_neg(:,1),features_neg(:,2),'o')
xlabel('Fundemental frequency (Hz)')
ylabel('Normalized spectral flux')