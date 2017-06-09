classdef ImageSegmenterFluorescentMembrane2D < CellVision3D.ImageSegmenter
    % The image segmeter class
    % used for image segmentation of fluorecent membrane type images
    % 11/20/2015 Yao zhao
    
    properties
        lobject=30 %length of the object
        lnoise=1  % scale of the noise
        ncycles=1 % number of cycles to search for global mininum for canny edge segmentation
    end
    
    properties (SetAccess = protected)
        mode='automatic'
    end
    
    properties (Constant)
        mode_options={'automatic', 'thresholding', 'cannyedge'}
    end
    
    methods
        % constructor
        function obj=ImageSegmenterFluorescentMembrane2D(varargin)
            obj@CellVision3D.ImageSegmenter(varargin{:});
        end
        
        % segment
        out=segment(obj,im);
        
        % manual segment
        out=segmentGUI(obj,im);
        
        % automatically segment
        out=segmentAuto(obj,im);
        
        % set mode
        function setMode(obj, mode)
            if sum(strcmp(mode, obj.mode_options)) ~= 1
                error('segmentation mod not supported');
            else
                obj.mode=mode;
            end
        end
    end
    
end

