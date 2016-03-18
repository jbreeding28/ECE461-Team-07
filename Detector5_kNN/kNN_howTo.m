clear
load fisheriris
X = meas; % use all data for fitting
Y = species; % response data

%% Creation, Training

% create and train the classifier
mdl = fitcknn(X,Y,'NumNeighbors',4);

% get error rate for points in the training data
rloss = resubLoss(mdl);

% create a cross-validated classifier
cvmdl = crossval(mdl);

% look at the error rate for the cross-validated model
kloss = kfoldLoss(cvmdl);

%% Predicting
% create an "average" flower
aveFlower = mean(X);

% look at the classification of the average flower
aveFlowerClass = predict(mdl,aveFlower);