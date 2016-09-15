classdef Contour3D < CellVision3D.Contour & CellVision3D.Object3D
    % 3d contour class for membrane analysis
    % data structure:
    % labe, dimension, zxr, numframes
    % vertices (cell numframes x 1)
    % faces (cell numframes x 1)
    
    % Yao Zhao 11/17/2015
    
    
    
    properties (SetAccess = protected)
        vertices % cell array of vertices of each frame, 
        % coordinates is in xyz, not correct for zxr
        faces % cell array of faces of each frame, will be same in this case
%         centroids % centroid of the analysis
    end
    properties
        tmpvertices % temporary vertices
        tmpfaces % temporary faces
%         tmpcentroids % temporary centroid
    end
    
    methods
        % constructor
        function obj = Contour3D(label,numframes,vertices,faces,zxr)
            obj@CellVision3D.Contour(label,numframes);
            obj.dimension=3;
            obj.vertices=cell(obj.numframes,1);
            obj.faces=cell(obj.numframes,1);
            obj.tmpvertices=vertices;
            obj.tmpfaces=faces;
%             obj.tmpcentroids=cnt;
            obj.zxr=zxr;
        end
        
        % addframe to acertain frame
        addFrame(obj,iframe,varargin)
        
        % get boundaries
        bb=getBoundaries(obj,varargin)
        
        % get centroids
        cnt=getCentroid(obj,varargin)
        
        % get volume
        vol=getVolume(obj,varargin);

        % get volume
        vol=getArea(obj,varargin);
        
        % get mean radius
        r=getMeanRadius(obj,varargin);

    end
    
end

