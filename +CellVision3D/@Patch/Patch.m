classdef Patch < CellVision3D.HObject
    % patch class a collection of partch operations
    
    properties (Access = protected)
        % patch properties
        ptspid % patch id for each pts
        facespid % patch id for each faces
        numpatches % number of total patches
        
        % mesh properties
        vertices % vertex position np*3, x,y,z
        faces % face vertex index nf*3, p1,p2,p3
        edges % edge information, ne*6, p1, p2, f1, f2, p3, p4,
        edges_lookup % look up table for edges, scale with numedges^2, ~MB storage
        neighbors % neighbor index of each points, structure of cells
        vertexnormals % vertex normals direction
        isoutward % face normal isoutward or not
    end
    
    properties (SetAccess = protected)
        % parameters for topology of mesh
        min_neighbor_number = 5
        max_neighbor_number = 6
        mesh_size = 2
    end
    
    methods
        % constructor
        function obj = Patch (p)
            obj.vertices = p.vertices;
            obj.faces = p.faces;
            obj.calculateEdgesAndNeighbors;
        end
    end
    
    methods (Access = public)
        [ obj ] = optimizeMesh( obj )
        
        [ patches ] = splitPatch( patch )
        
        [ obj ] = alignFaceDirection( obj )
        
        [ obj ] = calculateVertexNormalDirection( obj )
        
        [  ] = scale( patch, factors)
        
    end
    
    methods (Access = private)
        
        % calculate edges and neighbors
        [ obj ] = calculateEdgesAndNeighbors( obj );
        
        [ obj ] = labelPatch( obj )
        
        [ obj ] = balancePoints( obj )
        
        [ obj ] = balanceTopology( obj )
        
        [ obj ] = splitLargeQaudrangle( obj, th )
        
        [ obj ] = removeThreeWayConnectionPoints( obj )
        
        [ obj ] = removeFourWayConnectionPoints( obj )
        
    end
    
    
    methods (Access=public, Static)
        view(p , varargin);
    end
    
end

