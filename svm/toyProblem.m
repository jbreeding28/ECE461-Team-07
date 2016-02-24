% toyProblem.m
% Written by Matthew Boutell, 2006.
% Feel free to distribute at will.

clear all;

% We fix the seeds so the data sets are reproducible
seedTrain = 137;
seedTest = 138;
% This tougher data set is commented out.
%[xTrain, yTrain] = GenerateGaussianDataSet(seedTrain);
%[xTest, yTest] = GenerateGaussianDataSet(seedTest);

% This one isn't too bad at all
[xTrain, yTrain] = GenerateClusteredDataSet(seedTrain);
[xTest, yTest] = GenerateClusteredDataSet(seedTest);


% Add your code here.

net = svm(2,'rbf',[3],10);
net = svmtrain(net, xTrain, yTrain);
yTest_svmoutput = svmfwd(net,xTest);

failedInd = find(yTest_svmoutput~=yTest);
incorrectValues = yTest_svmoutput(failedInd);
numFalsePos = length(find(incorrectValues==1));
numFalseNeg = length(find(incorrectValues==-1));


% KNOWN ISSUE: the linear decision boundary doesn't work 
% for this data set at all. Don't know why...


% Run this on a trained network to see the resulting boundary 
% (as in the demo)
plotboundary(net, [0,20], [0,20]);


