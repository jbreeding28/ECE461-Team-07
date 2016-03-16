%% Plots
FFTPlotter.plotContact8_kNN('7 5-Audio, about 60 feet-1.wav');

%% SVM using our recordings
% Focusrite setup
filenames_pos = {...
    '9 6-Audio, steady whistling.wav',...
    '10 3-Audio-1,faint drone.wav',...
    '7 4-Audio, about 60 feet-1.wav',...
    '7 5-Audio, about 60 feet-1.wav'...
    '7 6-Audio, about 100 feet-1.wav'};
filenames_neg = {...
    '4 3-Audio-1, speech.wav',...
    '0005 3-Audio, go cart.wav'};

figure;
featData_pos = table;
for i = 1:length(filenames_pos)
    temp = FFTPlotter.fullLengthFeatureGen(filenames_pos{i});
    featData_pos = [featData_pos; temp];
end

figure;
featData_neg = table;
for i = 1:length(filenames_neg)
    temp = FFTPlotter.fullLengthFeatureGen(filenames_neg{i});
    featData_neg = [featData_neg; temp];
end

% format for support vector machine (SVM)
yTrain = [ones(size(featData_pos,1),1);-1*ones(size(featData_neg,1),1)];
xTrain = [table2array(featData_pos);table2array(featData_neg)];

net = svm(4,'rbf',[5],10);
net = svmtrain(net, xTrain, yTrain);

xTest_neg = table2array(FFTPlotter.fullLengthFeatureGen(...
    '6 3-Audio, Driveby.wav'));
yTest_neg = svmfwd(net,xTest_neg);

xTest_pos = table2array(FFTPlotter.fullLengthFeatureGen(...
    '7 3-Audio, Takeoff-1.wav'));
yTest_pos = svmfwd(net,xTest_pos);

% failedInd = find(yTest_svmoutput~=yTest);
% incorrectValues = yTest_svmoutput(failedInd);
% numFalsePos = length(find(incorrectValues==1));
% numFalseNeg = length(find(incorrectValues==-1));

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

% letters = {'A','B','C'};
% for fileNum = 1:length(filenames)
%     filedata = info{fileNum};
%     xlswrite('Features.xls',filedata',letters(fileNum));
% end
