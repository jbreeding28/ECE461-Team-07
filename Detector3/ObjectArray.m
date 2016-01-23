classdef ObjectArray
    
    properties
        x
    end
    
    methods
        
        function obj = ObjectArray(varargin)
            if nargin > 0
                obj = repmat(obj,[varargin{:}]);
            end
        end
        
    end
    
end
