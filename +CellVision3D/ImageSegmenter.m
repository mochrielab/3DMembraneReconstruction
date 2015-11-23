classdef ImageSegmenter < CellVision3D.HObject
    % The base calls for segmentation
    % can be extended to cell, nuclei for brightfields, fluroecence etc
    % 11/20/2015 Yao zhao
    
    properties
    end
    
    methods 
        % constructor
        function obj = ImageSegmenter(varargin)
            obj.setParam(varargin{:});
        end
    end    
    
    methods (Abstract)
        out=segment(obj,image);
    end
    
end

