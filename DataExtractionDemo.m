% Title: DataExtractionDemo.m
% Author: Wesley Mandel
% Date: 12/11/16
% Version: 1
%
% This file serves to demonstrate how to access the data inside of the .mat
% data package files. 
%
% The data must first be loaded to be accessed as seen in the assignment of
% the 'data' variable below. 
%
% Once loaded, thevariables stored inside of the .mat file can be accessed
% in a way similar to calling a method for an object in java. All that must
% be done is call the variable where everything is stored and add a
% '.variableName' to the end of the data variable.
% Ex)  data.ClassNumber calls up the array that has the class number for
% each row of data.
%
% The names of each variable that contains data is listed and explained
% below:
%
% ClassNumber: This is a column vector of doubles that contain the class 
% numbers assigned to each row of data. Each class was chosen to be the 
% source of the audio that the data was pulled from.The numbers are 
% assigned as follows: 0 = Cook Stadium, 1 = Iris+, 2 = Iris+ in the 
% anechoic chamber, 3 = Test Drone 1, 4 = Test Drone 2
%
% SouceFile: This is a column cell array of strings that indicate which
% sound file the data came from. 
%
% SourceFileChannel: This is a column vector of doubles that indicate which
% challen in the source audio file was the source of the data, as some
% audio files contained multiple channels to pull data from. Each channel
% was used individually for data in order to provide more for training and
% testing. 
%
% FundamnetalFrequency: This is a colum vector of doulbes that indicate the
% calculated fundamental frequency of the audio data. This fundamental
% frequency calculation isn't considered reliable yet, but is included to
% have a feature for comparison. The funciton used to cretae this specific
% data will be improved and updated so that in the future the testing data
% can be more accureate and overall useful.
%
% SpectrumCentroid: This is a column vector of doubles that indicate the
% freqeuncy at which the spectrum centroid is located. The method used to
% calculate this seems fairly reliable and useful. This function is still
% subject to future updates and new data will be presented as the function
% changes.
%
% VariableNames: This is a row cell array of strings that contain the above
% variable names. This vector is usefull simply for reference and for
% costructing a table as seen below. 
%
% Please note that the data inside of FundamentalFrequency and
% SpectrumCentroid can be used, but should not be considered absolutely
% correct at this time, simply because the funcitons that create these sets
% of data are under construction.
%
% This file is expected to be updated as new features are added and
% prexisting features are improved. 

clear all
close all
clc

data = load('DominantFrequencyData.mat');


% The statement below demonstrates how do access the variable fields inside
% of the testing data. This particulat line references the individual
% testing data variables that come fron the
% 'IndividualTestingDataVariables.mat' file. Remove the semicolon to have
% matlab display the created table in the workspace.

T = table(data.ClassNumber,data.SourceFile,...
   data.SourceFileChannel,data.DominantFrequency,...
   data.DominantFrequencyValue, data.SecondHighestFrequency,...
   data.SecondHighestFrequencyValue, data.ThirdHighestFrequency,...
   data.ThirdHighestFrequencyValue, data.FourthHighestFrequency,...
   data.FourthHighestFrequencyValue, data.FifthHighestFrequency,...
   data.FifthHighestFrequencyValue, 'VariableNames', data.VariableNames)

