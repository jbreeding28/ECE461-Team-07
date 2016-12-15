clear all;
load('DominantFrequencyData.mat');
% extract data from fisheriris to use only two categories
classes = ClassNumber;
class0 = classes(1);
class1 = classes(length(classes));
features = horzcat(double(DominantFrequency),double(DominantFrequencyValue));
modelFraction = 0.5;
class0Endpoint = 1;
for n = 1:length(classes)
    if(~eq(classes(n),class0))
        class0Endpoint = n - 1;
        break;
    end
end

class0Features = features(1:class0Endpoint,:);
class1Features = features(7:size(features,1),:);
class0ModelPoint = floor(size(class0Features,1)*0.5);
class1ModelPoint = floor(size(class1Features,1)*0.5);
class0Randomized = class0Features(randperm(size(class0Features,1)),:);
class1Randomized = class1Features(randperm(size(class1Features,1)),:);
class0Model = class0Randomized(1:class0ModelPoint,:);
class0Test = class0Randomized(class0ModelPoint + 1:size(class0Features),:);
class1Model = class1Randomized(1:class1ModelPoint,:);
class1Test = class1Randomized(class1ModelPoint + 1:size(class1Features),:);
modelData = vertcat(class1Model,class0Model);
testData = vertcat(class1Test,class0Test);
class1Identifier = 'drone';
class0Identifier = 'non-drone';
% Sets up the proper length arrays
class1 = cell(length(class1Model),1);
class1Test = cell(length(class1Test),1);
class1Test(:) = {class1Identifier};
class1(:) = {class1Identifier};
class0 = cell(length(class0Model),1);
class0Test = cell(length(class0Test),1);
class0(:) = {class0Identifier};
class0Test(:) = {class0Identifier};
modelClasses = categorical(vertcat(class1,class0));
testClasses = categorical(vertcat(class1Test,class0Test));
% separate out data into four vectors
meas1 = modelData(:,1);
meas2 = modelData(:,2);
% fit the data
[B,dev,stats] = mnrfit(modelData,modelClasses);
% create four linspace vectors to map probability to
% spread probability out slightly past the max and min to show for other
% data
range1 = (max(meas1) - min(meas1)) / 4;
range2 = (max(meas2) - min(meas2)) / 4;
n1 = linspace(max([0 min(meas1) - range1]),max(meas1) + range1,100);
n2 = linspace(max([0 min(meas2) - range2]),max(meas2) + range2,100);
% since the data is pre-separated by category, large pre-defined blocks can
% be extracted and separated
first1 = sort(meas1(length(meas1)-class0ModelPoint + 1:length(meas1)));
first2 = sort(meas1(1:length(meas1)-class0ModelPoint));
second1 = sort(meas2(length(meas2)-class0ModelPoint + 1:length(meas2)));
second2 = sort(meas2(1:length(meas2)-class0ModelPoint));
% zeros and ones to assign y values to the 
y1 = zeros(class0ModelPoint,1);
y2 = ones(class1ModelPoint,1);
% find average value of sample data
avg1 = mean(meas1);
avg2 = mean(meas2);
% create four plots, one where each parameter is varied
% each plot shows the actual sample data, given a class value of 1 or 0
% distributions of both classes are graphed as well
% the probability of the class based on the value of the x parameter is
% plotted in blck
fig = figure();
set(fig,'Position',[100 50 720 720]);
%suptitle(sprintf(['\\beta_{0}=' num2str(B(1)) ', p=' num2str(stats.p(1)) '\n\n']));
subplot(2,1,1);
scatter(first1,y1,70,'r');
hold on
[d11, x11] = ksdensity(first1);
plot(x11,d11,'r','Linewidth',3);
scatter(first2,y2,70,'b*');
[d12, x12] = ksdensity(first2);
plot(x12,d12,'b','Linewidth',3);
% the relative probability formula is created from the various parameters
% as given below. The probability is calculated and plotted below that
relativeProb = exp(B(1) + n1.*B(2) + avg2*B(3));
prob = relativeProb./(1+relativeProb);
plot(n1,prob,'k','Linewidth',2);
hold off
title(['Fundamental Frequency, \beta_{1}=' num2str(B(2)) ' ,p=' num2str(stats.p(2))]);
ylabel(['Class (1= drone ,0= non-drone)']);
xlabel('Fundamental Frequency (Hz)');

subplot(2,1,2);
scatter(second1,y1,70,'r');
hold on
[d21, x21] = ksdensity(second1);
plot(x21,d21,'r','Linewidth',3);
scatter(second2,y2,70,'b*');
[d22, x22] = ksdensity(second2);
plot(x22,d22,'b','Linewidth',3);
relativeProb = exp(B(1) + avg1*B(2) + n2.*B(3));
prob = relativeProb./(1+relativeProb);
plot(n2,prob,'k','Linewidth',2);
hold off
title(['Spectrum Centroid, \beta_{2}=' num2str(B(3)) ' ,p=' num2str(stats.p(3))]);
ylabel(['Class (1= drone ,0= non-drone)']);
xlabel('Spectrum Centroid (Hz)');

fig2 = figure();
set(fig2,'Position',[100 50 1280 720]);
relativeProbs = exp(ones(length(testData(:,1)),1).*B(1) + testData(:,1).*B(2)...
    + testData(:,2).*B(3));
probs = relativeProbs./(1+relativeProbs);
guessedClasses = cell(length(testData),1);
guessedClasses(:) = {'xxx'};
for n = 1:length(probs);
    if(probs(n) < 0.6)
        guessedClasses(n) = {'non-drone'};
    else
        guessedClasses(n) = {'drone'};
    end
end
data = uitable('Data',[cellstr(testClasses) cellstr(guessedClasses)...
    cellstr(num2str(probs)) cellstr(num2str(relativeProbs)) ],'ColumnName',...
    {'<html><font size=+2>Class','<html><font size=+2>Predicted Class',...
    '<html><font size=+2>Probability of drone',... 
    '<html><font size=+2>Relative probability of drone'},...
    'ColumnWidth', {150 200 350 545},'FontSize',15);
data.Position = [0 50 1280 620];