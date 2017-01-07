clear all;
load('DronesAndEnvironmentalNoiseData.mat');
% extract data from fisheriris to use only two categories
classes = ClassNumber;
class0 = classes(1);
class1 = classes(length(classes));
features = horzcat(double(DominantFrequency),double(DominantFrequencyValue),...
    double(SpectrumCentroid));
modelFraction = 0.7;
class0Endpoint = 1;
for n = 1:length(classes)
    if(~eq(classes(n),class0))
        class0Endpoint = n - 1;
        break;
    end
end

class0 = features(1:class0Endpoint,:);
class1 = features(class0Endpoint + 1:size(features,1),:);
[accuracy] = generateSystemModel(class1, class0,...
    0.5, 0.1, 0.5, 50);