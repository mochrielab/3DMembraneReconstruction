classdef MeshBuilder3DSphere < CellVision3D.MeshBuilder3D
    % class for building 3D contours
    % 12/4/2015
    % Yao Zhao
    
    properties
        rmin=3
        rmax=15;
        rstep=.3;
    end
    
    methods
        % constructor
        function obj=MeshBuilder3DSphere()
            obj@CellVision3D.MeshBuilder3D();
        end
    end
    
    methods (Static)
        [points,faces,edges,neighbors] = generateMeshSphere(N);
    end
    methods
        [outputpos] = fitMesh(obj,image3,initialpos,vertices,faces,edges,neighbors,varargin)
    end
    
end

