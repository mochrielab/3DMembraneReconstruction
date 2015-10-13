classdef hstruct < handle
    % create a handle for the data
    properties
        data
    end
    
    methods
        function obj = hstruct(varargin)
            if nargin==1
                obj.data = varargin{1};
            else
            end
        end
    end
end