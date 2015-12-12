classdef Contour3D < CellVision3D.Contour & CellVision3D.Object3D
    % 3d contour class for membrane analysis
    % Yao Zhao 11/17/2015
    properties (SetAccess = protected)
        vertices % cell array of vertices of each frame
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
        
        % set vertices at frame
        function setVertices(obj,vertices,iframe)
            obj.vertices{iframe}=vertices;
            obj.tmpvertices=vertices;
        end
        
              % set vertices at frame
        function setFaces(obj,faces,iframe)
            obj.faces{iframe}=faces;
            obj.tmpfaces=faces;
        end
        
        
    end
    
end

