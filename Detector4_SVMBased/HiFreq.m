filenames_pos = {...
    '9 6-Audio, steady whistling.wav',...
    '10 3-Audio-1,faint drone.wav',...
    '7 4-Audio, about 60 feet-1.wav',...
    '7 5-Audio, about 60 feet-1.wav'...
    '7 6-Audio, about 100 feet-1.wav'};
filenames_neg = {...
    '4 3-Audio-1, speech.wav',...
    '4 3-Audio-1, background noise.wav'...
    '0005 3-Audio, go cart.wav'};

featData_pos = zeros(1,64);
for i = 1:length(filenames_pos)
    temp = FeatureMachine.hifreqMeanMax(filenames_pos{i});
    %temp = table2array(temp)';
    featData_pos = [featData_pos; temp];
end
featData_pos = featData_pos(2:length(featData_pos),:);

figure;
%featData_neg = table;
featData_neg = zeros(1,64);
for i = 1:length(filenames_neg)
    temp = FeatureMachine.hifreqMeanMax(filenames_neg{i});
    featData_neg = [featData_neg; temp];
end
featData_neg = featData_neg(2:length(featData_neg),:);

% format for support vector machine (SVM)
yTrain = [ones(size(featData_pos,1),1);-1*ones(size(featData_neg,1),1)];
xTrain = [featData_pos;featData_neg];

net = svm(64,'rbf',[3],10);
net = svmtrain(net, xTrain, yTrain);

xTest_neg = FeatureMachine.hifreqMeanMax(...
    '6 3-Audio, Driveby.wav');
yTest_neg = svmfwd(net,xTest_neg);

xTest_pos = FeatureMachine.hifreqMeanMax(...
    '7 3-Audio, Takeoff-1.wav');
yTest_pos = svmfwd(net,xTest_pos);