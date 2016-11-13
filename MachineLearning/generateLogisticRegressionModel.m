function [B,dev,stats, accuracy] = generateLogisticRegressionModel(class1Data, class0Data,...
    modelPercentage, accuracyCutoff, probabilityCutoff, modelRuns)
if or(accuracyCutoff > 1, accuracyCutoff <= 0)
    error('Accuracy cutoff must be between 0 and 1');
end
if or(probabilityCutoff >= 1, probabilityCutoff <= 0)
    error('Probability cutoff must be between 0 and 1');
end
if or(modelPercentage >= 1,modelPercentage <= 0)
    error('Percentage of data for use in model must be between 0 and 1');
end
if modelRuns <= 0
    error('Number of model runs must be greater than 0');
end
cumulativeAccuracy = 0;
for n = 1:modelRuns
    cumulativeAccuracy = cumulativeAccuracy + testLogisticRegressionModel...
        (class1Data,class0Data,modelPercentage,probabilityCutoff); 
end
accuracy = cumulativeAccuracy / modelRuns;
if accuracy >= accuracyCutoff
    model1Length = floor(length(class1Data) * modelPercentage);
    model0Length = floor(length(class0Data) * modelPercentage);
    class1Identifier = 'one';
    class0Identifier = 'zero';
    class1 = cell(model1Length,1);
    class1(:) = {class1Identifier};
    class0 = cell(model0Length,1);
    class0(:) = {class0Identifier};
    class1Randomized = class1Data(randperm(size(class1Data,1)),:);
    class0Randomized = class0Data(randperm(size(class0Data,1)),:);
    class1ModelData = class1Randomized(1:model1Length,:);
    class0ModelData = class0Randomized(1:model0Length,:);
    data = vertcat(class1ModelData,class0ModelData);
    classes = categorical(vertcat(class1,class0));
    [B,dev,stats] = mnrfit(data,classes);
else
    B = 0;
    dev = 0;
    stats = 0;
end
