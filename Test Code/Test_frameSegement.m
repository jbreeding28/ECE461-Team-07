% linear indexing counts down columns, then rows; e.g:
% 1 4 7
% 2 5 8
% 3 6 9

clear

% case with no disregarded samples
vector = randn(1,50);
segmentsMatrix = frameSegment(vector,10);

% check values
for i = 1:length(vector)
    if(vector(i) ~= segmentsMatrix(i))
        error('frameSegment failed'); 
    end
end

% case with disregarded samples
vector = randn(1,27);
segmentsMatrix = frameSegment(vector,5);

% check size
if(size(segmentsMatrix)~=[5 5])
    error('frameSegment failed')
end

% check values
for i = 1:(length(vector)-2)
    if(vector(i) ~= segmentsMatrix(i))
        error('frameSegment failed'); 
    end
end

disp('frameSegment passed')

clear