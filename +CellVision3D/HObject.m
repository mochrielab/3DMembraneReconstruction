classdef HObject < handle
    %base class template for everything
    properties
    end
    
    methods
        % parameter setter
        function setParam(obj,varargin)
            n=floor(nargin/2);
            for i=1:n
                obj.(varargin{2*i-1})=varargin{2*i};
            end
        end
    end
    
end

