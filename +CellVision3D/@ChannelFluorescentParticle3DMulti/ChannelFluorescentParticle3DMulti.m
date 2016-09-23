
classdef ChannelFluorescentParticle3DMulti < CellVision3D.Channel & ...
        CellVision3D.ParticleTracker3D
    % channel for brightfield particles in 3D
    % 11/17/2015 Yao Zhao
    
    properties
        particles
    end
    
    properties (Access = public)
        multiplier = 1
        delta = 0.001
    end
    
    methods
        % constructor
        function obj=ChannelFluorescentParticle3DMulti(label,type)
            obj@CellVision3D.Channel(label,type);
        end

        % init
        particles=init(obj,i)
        
        % fit particles from the certain frame
        run(obj,input,varargin)
        
        % view
        view(obj)

    end
    
end

