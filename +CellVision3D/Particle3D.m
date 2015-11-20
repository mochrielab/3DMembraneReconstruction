classdef Particle3D < CellVision3D.Particle
    % class for 3D particle analysis
    % Yao Zhao 11/17/2015

    properties (SetAccess = protected)
        zxr=1       % z to xy ratio of the zstack
    end
    
    methods 
        % constructor
        function obj=Particle3D(label,pos,numframes,zxr)
            obj@CellVision3D.Particle(label,3,numframes);
            obj.tmppos=pos;
            obj.zxr=zxr;
        end
        % fit positions
       
        
    end
    
end

