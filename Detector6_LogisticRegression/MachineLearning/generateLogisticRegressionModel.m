function [B, dev, stats, accuracy] = generateLogisticRegressionModel(class1Data, class0Data,...
    modelPercentage,probabilityCutoff)
% TESTLOGISTICREGRESSIONMODEL Runs a single test of logistic regression
% CLASS1DATA A table of parameter values for class 1 data points
% CLASS0DATA A table of parameter values for class 0 data points
% MODELPERCENTAGE The percentage of data used in building the model
% PROBABILITYCUTOFF The probability of being class 1 which an individual 
% data point must meet to be considered a class 1

% Checks to make sure that the data is in matrix form
% and that the matrices have the same number of parameters
if or(or(~ismatrix(class1Data),~ismatrix(class0Data)),...
        ~eq(size(class1Data,2),size(class0Data,2)))
    error('Input data must be in matrix form with the same parameters');
end
class1Identifier = 'one';
class0Identifier = 'zero';
% Sets up the proper length arrays
model1Length = floor(length(class1Data) * modelPercentage);
model0Length = floor(length(class0Data) * modelPercentage);
class1 = cell(model1Length,1);
class1(:) = {class1Identifier};
class0 = cell(model0Length,1);
class0(:) = {class0Identifier};
% Randomizes the datasets
class1Randomized = class1Data(randperm(size(class1Data,1)),:);
class0Randomized = class0Data(randperm(size(class0Data,1)),:);
% Separates the data into model-building and test data
class1ModelData = class1Randomized(1:model1Length,:);
class0ModelData = class0Randomized(1:model0Length,:);
class1TestData = class1Randomized(model1Length+1:length(class1Randomized),:);
class0TestData = class0Randomized(model0Length+1:length(class0Randomized),:);
testData = vertcat(class1TestData,class0TestData);
guessedClasses = cell(size(testData,1),1);
guessedClasses(:) = {'xxx'};
% Concatenates the separated class data into full tables
modelData = vertcat(class1ModelData,class0ModelData);
classes = categorical(vertcat(class1,class0));
testClasses = (vertcat(repmat(class1(1),length(class1TestData),1),...
    repmat(class0(1),length(class0TestData),1)));
% Builds the model
[B,dev,stats] = mnrfit(modelData,classes);
% Tests test points
Boffset = B(1);
Bslopes = repmat(B(2:length(B))',size(testData,1),1);
relativeProbs = exp(Boffset + sum(Bslopes.*testData,2));
probs = relativeProbs./(1+relativeProbs);
% Places the test points into appropriate classes
for n = 1:length(probs)
    if(probs(n) < probabilityCutoff)
        guessedClasses(n) = {class0Identifier};
    else
        guessedClasses(n) = {class1Identifier};
    end
end
numberCorrect = 0;
% Checks which points were correctly classified
for m = 1:length(guessedClasses)
    guess = guessedClasses(m);
    actual = testClasses(m);
    if(strcmp(guess,actual))
        numberCorrect = numberCorrect + 1;
    end
end
accuracy = numberCorrect/length(testData);
    
    
