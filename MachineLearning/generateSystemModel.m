function [model, accuracy] = generateSystemModel(class1Data, class0Data,...
    modelPercentage, accuracyCutoff, probabilityCutoff, modelRuns)
% GENERATELOGISTICREGRESSIONMODEL Generate a logistic regression model
% CLASS1DATA A table of parameter values for class 1 data points
% CLASS0DATA A table of parameter values for class 0 data points
% MODELPERCENTAGE The percentage of data used in building the model
% ACCURACYCUTOFF The accuracy that the individual tests must average
% PROBABILITYCUTOFF The probability of being class 1 which an individual 
% data point must meet to be considered a class 1
% MODELRUNS The number of test runs

% Makes sure the accuracy cutoff is between 0 and 1
if or(accuracyCutoff > 1, accuracyCutoff <= 0)
    error('Accuracy cutoff must be between 0 and 1');
end
% Makes sure the probability cutoff is betwen 0 and 1
if or(probabilityCutoff >= 1, probabilityCutoff <= 0)
    error('Probability cutoff must be between 0 and 1');
end
% Makes sure the model percentage is between 0 and 1
if or(modelPercentage >= 1,modelPercentage <= 0)
    error('Percentage of data for use in model must be between 0 and 1');
end
% Checks that the number of model runs is greater than 0
if modelRuns <= 0
    error('Number of model runs must be greater than 0');
end
cumulativeAccuracy = 0;
bestAccuracy = accuracyCutoff;
% Run the test runs
% If a run's accuracy is better than the previous best,
% Set it as the model to return and use
for n = 1:modelRuns
    [Btest, devTest, statsTest, testAccuracy] = ...
        generateLogisticRegressionModel(class1Data,class0Data,...
        modelPercentage,probabilityCutoff);
    cumulativeAccuracy = cumulativeAccuracy + testAccuracy;
    if testAccuracy > bestAccuracy
        bestAccuracy = testAccuracy;
        B = Btest;
        dev = devTest;
        stats = statsTest;
    end
end
accuracy = cumulativeAccuracy / modelRuns;
% Does a final check to make sure average accuracy is above the limit
if accuracy < accuracyCutoff
    bestAccuracy = 0;
    bestTree = ClassificationTree();
    for n = 1:modelRuns
    [treeTest, testAccuracy] = ...
        generateClassificationTree(class1Data,class0Data);
    if testAccuracy > bestAccuracy
        bestTree = treeTest;
    end
    end
    model = bestTree;
else
    model = [B dev stats];
end
