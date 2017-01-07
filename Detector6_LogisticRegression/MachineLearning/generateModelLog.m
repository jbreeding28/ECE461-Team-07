function generateModelLog(modelType,model,runs,accuracy)
% GENERATEMODELLOG Creates a log of the generated model and stores it in a
% .mat file for logging purposes
date = fix(clock);
% Puts a timestamp in the filename
filename = strrep(strcat(datestr(clock),'.mat'), ':', '.');
save(filename,'modelType','model', 'runs', 'accuracy', 'date');

