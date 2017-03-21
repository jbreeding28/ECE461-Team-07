% This function calls all of the feature data extraction functions to get
% the audio feature data of each audio waveform entered into it. It follows
% the same parameter standards of CreateSignalProfile.m. It outputs a data
% capsule of all the calculated feature data that CreateSignalProfile.m can
% use to store that data into an actual signal profile. This function could
% also be used elsewhere.
%
% Inputs:
%
%    waveform: this is a matrix of audio waveform data. Each column of the
%    matrix is expected to be one audio waveform. This allows the user to
%    enter multiple waveforms with each being its own column of the matrix.
%    Reminder: ENTER THE WAVEFORM DATA AS A COLUMN FOR THIS FUNCTION TO
%    OPERATE PROPERLY.
%
%   Fs: This is the sampling frequency of the waveforms, which is assumend
%   to be the same for each since this funciton will exist solely in the
%   system's main code and there is a constant samping frequency.
%
%   SpectrumData: This is a matrix of frequency spectrums. Each column of
%   the matrix is a single frequency spectrum, and that spectrum is
%   expected to be the frequency spectrum for the audio waveform in the
%   corresponding column of the waveform variable. For example,
%   SpectrumData(:,2) is the frequency spectrum for waveform(:,2)'s audio
%   data.
%   Reminder: ENTER THE SPECTRUM DATA AS A COLUMN FOR THIS FUNCTIUON TO
%   OPERATE PROPERLY. ALSO, THE SPECTRUM PRESENT IN A GIVEN COLUMN MUST BE
%   THE SPECTRUM FOR THAT NUMBER COLUMN IN waveform. 
%
%   waveform and SpectrumData MUST be the same size for this funciton to
%   work.
%
% Outputs:
%
%   data: This is a data capsule of all of the feature data calculated in
%   this function. Any one particulat feature can be accessed from this
%   capsule in whatever function calls it by typing data.FeatureName. In
%   the example above, it is assumed that this function call is stored in a
%   variable called data. The .FeatureName can be any of the following
%   features:
%       .peakFreq
%       .Centroid
%       .CentroidValue
%       .silencePercentage
%       .specPeaks
%       .specPeaksFreqs
%       .STZCR
%       .AverageZCR
%       .ZCR
%       .STEnergy
%       .AverageEnergy
%       .Energy
%       .SpectrumFlux
function data = ProfileDetectionFeatures(waveform, spectrum, Fs,samples)
values = 5; %number of spectrum peaks to look for
MPD = 250; %minimum distance between spectrum peaks during search
segments = 10; %number of segments to break STZCR, STE, and Spectrum Flux into
overlap = 0; %number of samples to overlap when performing STZCR, STE, and Spectrum Flux calculations

numDataPoints = size(waveform,2); %find the number of waveforms in the matrix

%preemptively fill out arrays to store the feature calculations
Centroid = zeros([numDataPoints,1]);
CentroidValue = zeros([numDataPoints,1]);
silencePercentage = zeros([numDataPoints,1]);
specPeaks = zeros([numDataPoints,values]);
specPeaksFreqs = zeros([numDataPoints,values]);
STZCR = zeros([numDataPoints,segments]);
AverageZCR = zeros([numDataPoints,1]);
ZCR = zeros([numDataPoints,1]);
STEnergy = zeros([numDataPoints,segments]);
AverageEnergy = zeros([numDataPoints,1]);
Energy = zeros([numDataPoints,1]);
SpectrumFlux = zeros([numDataPoints,segments]);

silenceThreshold = 0.002; %set threshold for the silence detection feature

%calculate the features
for i = 1:numDataPoints
    [Centroid(i), CentroidValue(i)] = GetSpectrumCentroid(spectrum(1:samples(i),i),Fs);
    silencePercentage(i) = GetSilencePercentage(waveform(1:samples(i),i), Fs,0,silenceThreshold);
    [specPeaks(i,:), specPeaksFreqs(i,:)] = GetPeaks(spectrum(1:samples(i),i), Fs, values, MPD);
    [STZCR(i,:), AverageZCR(i), ZCR(i)] = GetZCRInfo(waveform(1:samples(i),i),Fs,segments,overlap);
    [STEnergy(i,:), AverageEnergy(i), Energy(i)] = GetEnergyInfo(waveform(1:samples(i),i),segments,overlap);
    SpectrumFlux(i,:) = GetSpectrumFlux(waveform(1:samples(i),i),segments,overlap);
end

%Store the calculated features inside of data
    data.Centroid = Centroid;
    data.CentroidValue = CentroidValue;
    data.silencePercentage = silencePercentage;
    data.specPeaks = specPeaks;
    data.specPeaksFreqs = specPeaksFreqs;
    data.STZCR = STZCR;
    data.AverageZCR = AverageZCR;
    data.ZCR = ZCR;
    data.STEnergy = STEnergy;
    data.AverageEnergy = AverageEnergy;
    data.Energy = Energy;
    data.SpectrumFlux = SpectrumFlux;
end