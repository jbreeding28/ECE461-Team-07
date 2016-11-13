function generateModelLog(B,dev,stats,runs,accuracy)
date = clock;
filename = strrep(strcat(datestr(clock),'.mat'), ':', '.');
save(filename, 'B', 'dev', 'stats', 'runs', 'accuracy', 'date');

