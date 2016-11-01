function accuracy = testLogisticRegressionModel(class1Data, class0Data, modelPercentage)
if or(~ismatrix(class1Data),~ismatrix(class0Data))
    error('Input data must be in matrix form');
end
if(modelPercentage >= 1)
    error('Percentage of data for use in model must be less than 1');
end
class1Identifier = 'one';
class0Identifier = 'zero';
model1Length = floor(length(class1Data) * modelPercentage);
model0Length = floor(length(class0Data) * modelPercentage);
class1 = cell(model1Length,1);
class1(:) = {class1Identifier};
class0 = cell(model0Length,1);
class0(:) = {class0Identifier};
class1Randomized = class1Data(randperm(size(class1Data,1)),:);
class0Randomized = class0Data(randperm(size(class0Data,1)),:);
class1ModelData = class1Randomized(1:model1Length,:);
class0ModelData = class0Randomized(1:model0Length,:);
class1TestData = class1Randomized(model1Length+1:length(class1Randomized),:);
class0TestData = class0Randomized(model0Length+1:length(class0Randomized),:);
testData = vertcat(class1TestData,class0TestData);
guessedClasses = cell(size(testData,1),1);
guessedClasses(:) = {'xxx'};
modelData = vertcat(class1ModelData,class0ModelData);
classes = categorical(vertcat(class1,class0));
testClasses = (vertcat(repmat(class1(1),length(class1TestData),1),...
    repmat(class0(1),length(class0TestData),1)));
[B,dev,stats] = mnrfit(modelData,classes);
Boffset = B(1);
Bslopes = repmat(B(2:length(B))',size(testData,1),1);
multiplied = Bslopes.*testData;
summedRows = sum(multiplied,2);
relativeProbs = exp(Boffset + sum(Bslopes.*testData,2));
probs = relativeProbs./(1+relativeProbs);
for n = 1:length(probs)
    if(probs(n) < 0.5)
        guessedClasses(n) = {class0Identifier};
    else
        guessedClasses(n) = {class1Identifier};
    end
end
numberCorrect = 0;
for m = 1:length(guessedClasses)
    guess = guessedClasses(m);
    actual = testClasses(m);
    if(strcmp(guessedClasses(m),testClasses(m)))
        numberCorrect = numberCorrect + 1;
    end
end
accuracy = numberCorrect/length(testData);
    
    
