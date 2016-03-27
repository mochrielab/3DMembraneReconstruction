
classdef ChannelFluorescentMembrane3D < CellVision3D.Channel ...
        & CellVision3D.MeshBuilder3D & ...
        CellVision3D.ImageSegmenterFluorescentMembrane3D
    % channel for spherical fluroescent membranes
    % 11/17/2015 Yao Zhao
    
    properties
        contours
    end
    
    methods
        % constructor
        function obj=ChannelFluorescentMembrane3D(label,type)
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

