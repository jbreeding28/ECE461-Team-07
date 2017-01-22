            %load('DataCollection_1_18_2017.mat');
            
            load('DataCollection_1_18_2017.mat');
            % DS.localiz = localizer;
            classes = ClassNumber;
            %features = double(DominantFrequencyValue);
            modelFeatures = horzcat(double(DominantFrequency),double(SecondHighestFrequency),...
                double(DominantFrequencyValue),double(SecondHighestFrequencyValue));
            %DS.features = zeros(size(modelFeatures,2),DS.c.NUM_CHANNELS);
            %    double(SpectrumCentroid));
            class0Endpoint = 1;
            for n = 1:length(classes)
                if(~eq(classes(n),classes(1)))
                    class0Endpoint = n - 1;
                    break;
                end
            end
            modelPercentage = 0.5;
            probabilityCutoff = 0.65;
            DS.droneProbabilityCutoff = 0.65;
            modelRuns = 50;

            class1Identifier = 'one';
            class0Identifier = 'zero';
            class0Data = modelFeatures(1:class0Endpoint,:);
            class1Data = modelFeatures(class0Endpoint + 1:size(modelFeatures,1),:);
            class1 = cell(size(class1Data,1),1);
            class1(:) = {class1Identifier};
            class0 = cell(size(class0Data,1),1);
            class0(:) = {class0Identifier};
            classes = categorical(vertcat(class1,class0));
            data = vertcat(class1Data,class0Data);
            
            %[B, dev, stats] = mnrfit(data,classes);
            [B, dev, stats, accuracy] = ...
                generateSystemModel(class1Data, class0Data,...
                modelPercentage, probabilityCutoff, modelRuns);
            Boffset = B(1);
            Bslopes = B(2:length(B));
            cutoff = probabilityCutoff;
            bufferedAudio = zeros(45056,4);
            %transform = zeros(45056,4);
            [bufferedAudio(:,1),fs] = audioread('CookField-Drone-1-18_1_1.wav');
            [bufferedAudio(:,2),fs] = audioread('CookField_OddDetectionScenario_2.wav');
            [bufferedAudio(:,3),fs] = audioread('CookField_OddDetectionScenario_3.wav');
            [bufferedAudio(:,4),fs] = audioread('CookField_OddDetectionScenario_4.wav');
            features = zeros(4,4);
            pwrs = zeros(4,1);
            for i = 1:4
                transform = abs(fftshift(fft(bufferedAudio(:,i))));
                binsize_Hz = (44100/2)/(4096/2+1);
                midPoint = ceil(length(transform)/2);
                transform(midPoint - ceil(150/binsize_Hz): midPoint + ceil(150/binsize_Hz) + 1) = 0;
                [spectrumCentroid centroidValue] = GetSpectrumCentroid(transform);
                [dominantFrequencyValues dominantFrequencies] = GetPeaks(transform);
                domFreq1 = dominantFrequencies(1);
                domFreq2 = dominantFrequencies(2);
                domFreq3 = dominantFrequencies(3);
                domFreq4 = dominantFrequencies(4);
                domFreq5 = dominantFrequencies(5);
                domValue1 = dominantFrequencyValues(1);
                domValue2 = dominantFrequencyValues(2);
                domValue3 = dominantFrequencyValues(3);
                domValue4 = dominantFrequencyValues(4);
                domValue5 = dominantFrequencyValues(5);
                features(:,i) = vertcat(domFreq1,domFreq2,...
                    domValue1,domValue2);
                pwrs(i) = mag2db(rms(bufferedAudio(:,i)));
            end
            relativeProbs = zeros(4,1);
            probs = zeros(4,1);
            for i = 1:4
            relativeProbs(i) = exp(Boffset + sum(Bslopes.*features(:,i)));
            if isinf(relativeProbs(i))
                probs(i) = 1
            else
                probs(i) = relativeProbs(i)./(1+relativeProbs(i))
            end
            end