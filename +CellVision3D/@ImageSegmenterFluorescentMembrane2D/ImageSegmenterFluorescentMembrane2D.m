classdef ImageSegmenterFluorescentMembrane2D < CellVision3D.ImageSegmenter
    % The image segmeter class
    % used for image segmentation of fluorecent membrane type images
    % 11/20/2015 Yao zhao
    
    properties
        lobject=30 %length of the object
        lnoise=1  % scale of the noise
        ncycles=1 % number of cycles to search for global mininum for canny edge segmentation
    end
    
    methods
        out=segment(obj,im)
    end
    
end

