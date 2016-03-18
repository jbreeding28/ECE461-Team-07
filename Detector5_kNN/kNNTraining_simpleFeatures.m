% k-NN
%% Training
clear
filenames_pos = {...
    '9 6-Audio, steady whistling.wav',...
    '10 3-Audio-1,faint drone.wav',...
    '7 4-Audio, about 60 feet-1.wav',...
    '7 5-Audio, about 60 feet-1.wav'...
    '7 6-Audio, about 100 feet-1.wav'};
filenames_neg = {...
    '4 3-Audio-1, speech.wav',...
    '0005 3-Audio, go cart.wav',...
    'Birds and stuff.wav'...
    'frog noise 1.wav'};

features_pos = [0,0,0];
features_neg = [0,0,0];

for i = 1:length(filenames_pos)
    theseFeatures = FFTPlotter.fullLengthFeatureGen_kNN(filenames_pos{i});
    features_pos = [features_pos; theseFeatures];
end

features_pos = features_pos(2:length(features_pos),:);
    
for i = 1:length(filenames_neg)
    theseFeatures = FFTPlotter.fullLengthFeatureGen_kNN(filenames_neg{i});
    features_neg = [features_neg; theseFeatures];
end

features_neg = features_neg(2:length(features_neg),:);

X = [features_pos; features_neg];
Y = cell(0);
for i = 1:length(features_pos)
    Y = [Y;'drone signal'];
end
for i = 1:length(features_neg)
    Y = [Y;'non-drone signal'];
end

% create and train the classifier
mdl = fitcknn(X,Y,'NumNeighbors',3);
% flexability and number of neighbors are inversely related
% flexability and how tightly the training data is fit is directly related

% should loop over all possible neighbors and see what yeilds low error for
% both testing and training data (like we did in machine learning)

% get error rate for points in the training data
rloss = resubLoss(mdl);

% create a cross-validated classifier
cvmdl = crossval(mdl);

% look at the error rate for the cross-validated model
kloss = kfoldLoss(cvmdl);

%% Testing
Xtest = FFTPlotter.fullLengthFeatureGen_kNN('6 3-Audio, Drone and frog noise.wav');
Ytest = predict(mdl,Xtest);
length(find(strcmp(Ytest,'drone signal')))/length(Ytest)
Xtest = FFTPlotter.fullLengthFeatureGen_kNN('0011 Internet, Alt J.wav');
Ytest = predict(mdl,Xtest);
length(find(strcmp(Ytest,'non-drone signal')))/length(Ytest)