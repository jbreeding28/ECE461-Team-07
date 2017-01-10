function [tree, accuracy] = generateClassificationTree(class1Data, class0Data)
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
% Concatenates the separated class data into full tables
modelData = vertcat(class1ModelData,class0ModelData);
classes = categorical(vertcat(class1,class0));
testClasses = (vertcat(repmat(class1(1),length(class1TestData),1),...
    repmat(class0(1),length(class0TestData),1)));
tree = fitctree(modelData,classes);
guessedClasses = cell(predict(tree,testData));
numberCorrect = 0;
% Checks which points were correctly classified
for m = 1:length(guessedClasses)
    guess = guessedClasses(m);
    actual = testClasses(m);
    if(strcmp(guess,actual)
        numberCorrect = numberCorrect + 1;
    end
end
accuracy = numberCorrect/length(testData);