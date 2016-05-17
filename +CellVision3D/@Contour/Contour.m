classdef Contour < matlab.mixin.Heterogeneous & CellVision3D.HObject & CellVision3D.UserData
    %   base contour class
    % 11/22/2015 Yao Zhao
    
    properties (SetAccess = protected)
        label % label for the membrane
        dimension % dimension
        numframes % number of frames
        pix2um=1 % pixel to micron conversion
    end
    properties (Access = protected)
        iframe=0 % current frame
    end
    
    methods
        function obj = Contour (label,numframes)
            obj.label=label;
            obj.numframes=numframes;
        end
        
        function setPix2um (obj,pixel2um)
            obj.pix2um = pixel2um;
        end
    end
    
end

