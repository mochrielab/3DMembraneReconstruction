classdef Contour3D < CellVision3D.Contour
    % 3d contour class for membrane analysis
    % Yao Zhao 11/17/2015
    properties (SetAccess = protected)
        vertices % cell array of vertices of each frame
        faces % cell array of faces of each frame, will be same in this case
        centroids % centroid of the analysis
        zxr % zxr ratio
    end
    properties
        tmpvertices % temporary vertices
        tmpfaces % temporary faces
        tmpcentroids % temporary centroid
    end
    
    methods
        % constructor
        function obj = Contour3D(label,numframes,vertices,faces,cnt,zxr)
            obj@CellVision3D.Contour(label,numframes);
            obj.dimension=3;
            obj.vertices=cell(obj.numframes,1);
            obj.faces=cell(obj.numframes,1);
            obj.tmpvertices=vertices;
            obj.tmpfaces=faces;
            obj.tmpcentroids=cnt;
            obj.zxr=zxr;
        end
    end
    
end

