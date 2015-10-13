classdef mesh3 < handle 
    %3d mesh class that is used to fit to a membrane image
    %3/12/2015 Yao Zhao
    
    properties
        % image properties
        rawimage % un preprocessed raw image
        image % img for fitting
        zxr=1 % z slice to xy ratio for the 3d image
        bwsurf % bw surface image for coarse membrane track
        L % label of image used for image partition
        
        % prefilter setting
        % gaussian smooth size, background remove size , cut background 80%
        preprocessth=[.1 5 .8]
        
        % 3d canny surface threshold
        % strong edge, weak edge, surface remove angle (0.1,.8)
        % the smaller th(3) is, the less connected is the surface
        cannyth=[.8 .1 .5]
        
        % parameters for topology of mesh
        min_neighbor_number = 5
        max_neighbor_number = 6
        mesh_size = 2
        
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
        
        % surface shell image interpolation
        shellstep=0.3; % shell sampling step
        shellstepnum=6; % number of shell step on each direction
        shellimage
        
        %surface fitting
        %computational bending cost
        cost
        
        % diagnostic
        diagnostic_mod_on=0;
        
        % custom data
        identifier
    end
    
    methods
        % basic operation
        % construction method
        function obj=mesh3(rawimg3,varargin)
            obj.rawimage=rawimg3;
            if nargin==1;
                obj.zxr=1;
            elseif nargin>=2;
                obj.zxr=varargin{1};
            end
        end
        % compress data for saving
        [ obj ] = CompressMesh3( obj )
        % copy from aonther 
        obj=CopyFrom(obj,obj2);
        
        % creat initial mesh, using laplacian
        obj=InitializeMesh(obj);
        % process raw image 
        obj=PreProcessImage(obj)
        
        % geometry functions:
        % optimize mesh
        obj=OptimizeMesh(obj);
        % topology switch mesh
        obj=TopologySwitch(obj);
        % balance vertices positions
        obj=BalancePoints(obj);
        % calculate all the edges and neighbors
        obj=GetEdgesAndNeighbors(obj);
        % split the large shape qaudrangles
        obj=SplitLargeQaudrangle(obj,sizeth);
        % balance the faces
        obj=BalaceTriangleArea(obj);
        % remove point with 4 connnection
        obj=RemoveFourWayConnectionPoints( obj )
        % remove 3 way connection
        obj=RemoveThreeWayConnectionPoints(obj);
        % remove nearby two five way connection
        obj=RemoveNearbyFiveWayConnectionPoints(obj);
        
        % patch functions
        % label the id of patches
        [ obj ] = LabelPatchId( obj )
        % rearrange faces to face same direction
        obj=AlignFaceDirection(obj);
        
        % plotting functions
        % plot crude image
        obj=PlotCrudeSurface(obj);
        % plot mesh surface
        obj=PlotMesh(obj);
        % plot mesh surface stack
        obj=PlotMeshStack(obj,varargin);
        % plot mesh simple
        obj=PlotMeshSim(obj);
        % get cross section of plane
        [ allcontours,lowerfaces,lowerpoints ] = GetCrossSection( obj,v )
        % plot image partition
        [ obj ] = PlotImagePartition( obj ) 
        % plot mesh with curvature
        [ obj ] = PlotMeshCurvature( obj )
        
        % geometry operations
        % get total area of each patch
        [ areas ] = GetArea( obj )
        % get total volume of each patch
        [ obj ] = GetVolume( obj )
        
        % compare similarity
        [ obj ] = CompareShape ( obj, obj2 )
        
        % fit surface
        % surface sub pix fitting
        obj=GetSurfaceInterpImage(obj);
        % fit surface
        obj=FitSurface(obj,varargin);% can add a searchconst to bias the searching
        % get normal face direction at each vertex point
        obj=GetVertexNormalDirection(obj);

        % debugging 
        % debugg topology
        obj=DiagnoseMeshTopology( obj )

    end
    
end

