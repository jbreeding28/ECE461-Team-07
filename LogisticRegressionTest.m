clear all;
load fisheriris;
% extract data from fisheriris to use only two categories
extractedData = [51:150];
modelLength = 20;
testLength = 10;
actualTestLength = min((length(extractedData)/2) - modelLength,testLength);
midPoint = (length(extractedData)/2);
modelRange = [1:modelLength midPoint+1:midPoint+modelLength];
testRange = [modelLength+1:modelLength+actualTestLength...
    midPoint+1+modelLength:midPoint+modelLength+actualTestLength];
spExtract = (species(extractedData));
sp = categorical(spExtract(modelRange));
spTest = categorical(spExtract(testRange));
measExtract = (meas(extractedData,:));
measExtract1 = measExtract(1:midPoint,:);
measExtract2 = measExtract(midPoint+1:length(measExtract),:);
measRandom1 = measExtract1(randperm(size(measExtract1,1)),:);
measRandom2 = measExtract2(randperm(size(measExtract2,1)),:);
measRandomized = vertcat(measRandom1,measRandom2);
measured = measRandomized(modelRange,:);
measuredTest = measRandomized(testRange,:);
% separate out data into four vectors
meas1 = measured(:,1);
meas2 = measured(:,2);
meas3 = measured(:,3);
meas4 = measured(:,4);
% fit the data
[B,dev,stats] = mnrfit(measured,sp);
% create four linspace vectors to map probability to
% spread probability out slightly past the max and min to show for other
% data
range1 = (max(meas1) - min(meas1)) / 4;
range2 = (max(meas2) - min(meas2)) / 4;
range3 = (max(meas3) - min(meas3)) / 4;
range4 = (max(meas4) - min(meas4)) / 4;
n1 = linspace(max([0 min(meas1) - range1]),max(meas1) + range1,100);
n2 = linspace(max([0 min(meas2) - range2]),max(meas2) + range2,100);
n3 = linspace(max([0 min(meas3) - range3]),max(meas3) + range3,100);
n4 = linspace(max([0 min(meas4) - range4]),max(meas4) + range4,100);
% since the data is pre-separated by category, large pre-defined blocks can
% be extracted and separated
first1 = sort(meas1(modelLength+1:2*modelLength));
first2 = sort(meas1(1:modelLength));
second1 = sort(meas2(modelLength+1:2*modelLength));
second2 = sort(meas2(1:modelLength));
third1 = sort(meas3(modelLength+1:2*modelLength));
third2 = sort(meas3(1:modelLength));
fourth1 = sort(meas4(modelLength+1:2*modelLength));
fourth2 = sort(meas4(1:modelLength));
% zeros and ones to assign y values to the 
y1 = zeros(modelLength,1);
y2 = ones(modelLength,1);
% find average value of sample data
avg1 = mean(meas1);
avg2 = mean(meas2);
avg3 = mean(meas3);
avg4 = mean(meas4);
% create four plots, one where each parameter is varied
% each plot shows the actual sample data, given a class value of 1 or 0
% distributions of both classes are graphed as well
% the probability of the class based on the value of the x parameter is
% plotted in blck
fig = figure();
set(fig,'Position',[100 50 1280 720]);
suptitle(sprintf(['\\beta_{0}=' num2str(B(1)) ', p=' num2str(stats.p(1)) '\n\n']));
subplot(2,2,1);
scatter(first1,y1,70,'r');
hold on
[d11, x11] = ksdensity(first1);
plot(x11,d11,'r','Linewidth',3);
scatter(first2,y2,70,'b*');
[d12, x12] = ksdensity(first2);
plot(x12,d12,'b','Linewidth',3);
% the relative probability formula is created from the various parameters
% as given below. The probability is calculated and plotted below that
relativeProb = exp(B(1) + n1.*B(2) + avg2*B(3) + avg3*B(4) + avg4*B(5));
prob = relativeProb./(1+relativeProb);
plot(n1,prob,'k','Linewidth',2);
hold off
legend([char(sp(length(sp))) ' data'],[char(sp(length(sp))) ' distribution'],...
    [char(sp(1)) ' data'], [char(sp(1)) ' distribution'],['probability of ' char(sp(1))]);
title(['Flower Class vs. Sepal Length, \beta_{1}=' num2str(B(2)) ' ,p=' num2str(stats.p(2))]);
ylabel(['Flower Class (1=' char(sp(1)) ' ,0=' char(sp(length(sp))) ')']);
xlabel('Sepal Length (cm)');

subplot(2,2,2);
scatter(second1,y1,70,'r');
hold on
[d21, x21] = ksdensity(second1);
plot(x21,d21,'r','Linewidth',3);
scatter(second2,y2,70,'b*');
[d22, x22] = ksdensity(second2);
plot(x22,d22,'b','Linewidth',3);
relativeProb = exp(B(1) + avg1*B(2) + n2.*B(3) + avg3*B(4) + avg4*B(5));
prob = relativeProb./(1+relativeProb);
plot(n2,prob,'k','Linewidth',2);
hold off
title(['Flower Class vs. Sepal Width, \beta_{2}=' num2str(B(3)) ' ,p=' num2str(stats.p(3))]);
ylabel(['Flower Class (1=' char(sp(1)) ' ,0=' char(sp(length(sp))) ')']);
xlabel('Sepal Width (cm)');


subplot(2,2,3);
scatter(third1,y1,70,'r');
hold on
[d31, x31] = ksdensity(third1);
plot(x31,d31,'r','Linewidth',3);
scatter(third2,y2,70,'b*');
[d32, x32] = ksdensity(third2);
plot(x32,d32,'b','Linewidth',3);
relativeProb = exp(B(1) + avg1*B(2) + avg2*B(3) + n3.*B(4) + avg4*B(5));
prob = relativeProb./(1+relativeProb);
plot(n3,prob,'k','Linewidth',2);
hold off
title(['Flower Class vs. Petal Length, \beta_{3}=' num2str(B(4)) ' ,p=' num2str(stats.p(4))]);
ylabel(['Flower Class (1=' char(sp(1)) ' ,0=' char(sp(length(sp))) ')']);
xlabel('Petal Length (cm)');

subplot(2,2,4);
scatter(fourth1,y1,70,'r');
hold on
[d41, x41] = ksdensity(fourth1);
plot(x41,d41,'r','Linewidth',3);
scatter(fourth2,y2,70,'b*');
[d42, x42] = ksdensity(fourth2);
plot(x42,d42,'b','Linewidth',3);
relativeProb = exp(B(1) + avg1*B(2) + avg2*B(3) + avg3*B(4) + n4.*B(5));
prob = relativeProb./(1+relativeProb);
plot(n4,prob,'k','Linewidth',2);
hold off
title(['Flower Class vs. Petal Width, \beta_{4}=' num2str(B(5)) ' ,p=' num2str(stats.p(5))]);
ylabel(['Flower Class (1=' char(sp(1)) ' ,0=' char(sp(length(sp))) ')']);
xlabel('Petal Width (cm)');

fig2 = figure();
set(fig2,'Position',[100 50 1280 720]);
relativeProbs = exp(ones(length(measuredTest(:,1)),1).*B(1) + measuredTest(:,1).*B(2)...
    + measuredTest(:,2).*B(3) + measuredTest(:,3).*B(4) + measuredTest(:,4).*B(5));
probs = relativeProbs./(1+relativeProbs);
guessedClasses = cell(actualTestLength*2,1);
guessedClasses(:) = {'xxx'};
for n = 1:length(probs);
    if(probs(n) < 0.5)
        guessedClasses(n) = {char(spTest(length(spTest)))};
    else
        guessedClasses(n) = {char(spTest(1))};
    end
end
data = uitable('Data',[cellstr(spTest) cellstr(guessedClasses)...
    cellstr(num2str(probs)) cellstr(num2str(relativeProbs)) ],'ColumnName',...
    {'<html><font size=+2>Class','<html><font size=+2>Predicted Class',...
    '<html><font size=+2>Probability of versicolor',... 
    '<html><font size=+2>Relative probability of versicolor'},...
    'ColumnWidth', {150 200 350 545},'FontSize',15);
data.Position = [0 50 1280 620];






