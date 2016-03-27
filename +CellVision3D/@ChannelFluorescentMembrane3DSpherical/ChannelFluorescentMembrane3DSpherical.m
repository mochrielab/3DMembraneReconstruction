
classdef ChannelFluorescentMembrane3DSpherical < CellVision3D.Channel ...
        & CellVision3D.MeshBuilder3DSphere & ...
        CellVision3D.ImageSegmenterFluorescentMembrane3DSphere
    % channel for spherical fluroescent membranes
    % 11/17/2015 Yao Zhao
    
    properties
        contours
    end
    
    methods
        % constructor
        function obj=ChannelFluorescentMembrane3DSpherical(label,type)
            obj@CellVision3D.Channel(label,type);
        end
        
        % init analysis
        contours=init(obj,iframe)
        
        % run analysis
        run(obj,input,varargin)
        
        % view
        view(obj)
        
    end
    
end

