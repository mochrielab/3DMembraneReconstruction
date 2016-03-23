classdef MeshBuilder3DSphere < CellVision3D.MeshBuilder3D
    % class for building 3D contours for spherical type shape
    % for general type refer to MeshBuilder3D and Mesh3D
    % 12/4/2015
    % Yao Zhao
    
    properties (Access = protected)
        rmin=3; % min radius of mesh
        rmax=15; % max radius of mesh
        rstep=.3; % interpolation stepping of radius
        ndivision = 3; % mesh division parameter, the larger the finer
    end
    
    methods
        % constructor
        function obj=MeshBuilder3DSphere()
            obj@CellVision3D.MeshBuilder3D();
        end
    end
    
    methods (Static)
        % generate a 3D sphere mesh
        [points,faces,edges,neighbors] = generateMeshSphere(N);
    end
    methods
        % fit mesh to a image stack
        [outputpos] = fitMesh(obj,image3,initialpos,vertices,faces,edges,neighbors,varargin)
        % update the radius parameter based on segmented output
        [  ] = updateRadiusParam( obj, out )
    end
    
end

