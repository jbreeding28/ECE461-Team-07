function [ index ] = sortHW( sortedArray, toFind )

    low = 0;
    high = length(sortedArray)-1;
    mid = 0;
    
    while(sortedArray((low+1)) <= toFind && sortedArray((high+1)) >= toFind)
        mid = (low+1)+((toFind-sortedArray((low+1)))*((high+1)-(low+1)))/(sortedArray((high+1))-sortedArray((low+1)));
        if (sortedArray(mid) < toFind) low = mid+1;
        elseif (sortedArray(mid) > toFind) high = mid - 1;
        else index = mid; return;  
        end
    end
    
    if(sortedArray(toFind+1)==toFind) 
        index = low; return;
    else
        index = -1;
    end

end

