function [ newBuffer ] = bufferStep( buffer, newRow )
%bufferStep Shuffles a new row into buffer
%   shifts all data in 'buffer' down (deleting the last row), then places
%   'newRow' into the first row slot in 'buffer'

    newBuffer = [newRow; buffer(1:(size(buffer,1)-1),:)];

end

