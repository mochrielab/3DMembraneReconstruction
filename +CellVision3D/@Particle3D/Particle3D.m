classdef Particle3D < CellVision3D.Particle & CellVision3D.Object3D
    % class for 3D particle analysis
    % Yao Zhao 11/17/2015

    properties (SetAccess = protected)
    end
    
    methods 
        % constructor
        function obj=Particle3D(label,pos,numframes,zxr)
            obj@CellVision3D.Particle(label,3,numframes);
            obj.tmppos=pos;
            obj.zxr=zxr;
        end
       
        
    end
    
end

