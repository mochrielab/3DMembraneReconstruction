classdef HObject < handle
    %base class template for everything
    properties (Access = private)
    end
    
    methods
        
        % parameter setter
        % override access, should be only used for debugging
        function setParam(obj,varargin)
            n=floor(nargin/2);
            for i=1:n
                obj.(varargin{2*i-1})=varargin{2*i};
            end
        end
        
        
        % get parameter
        % override access, should be only used for debugging
        function param = getParam(obj,string)
            param = obj.(string);
        end
        
        
    end
    
    methods (Static, Access = public)
                % search for string
        function found=check(strings,string)
            found=false;
            for i=1:length(strings)
                if strcmp(strings{i},string)
                    found=true;
                    return;
                end
            end
        end
    end
end    
