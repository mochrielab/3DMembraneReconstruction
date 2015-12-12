
classdef ChannelFluorescentParticle3D < CellVision3D.Channel & ...
        CellVision3D.ParticleTracker3D
    % channel for brightfield particles in 3D
    % 11/17/2015 Yao Zhao
    
    properties
        particles
    end
    
    methods
        % constructor
        function obj=ChannelFluorescentParticle3D(label,type)
            obj@CellVision3D.Channel(label,type);
        end
        % generate cells from the a selected frame
        function particles=init(obj,i)
            % get image
            img=obj.grabImage3D(i);
            % get cell contours
            pos=obj.getPositions( img,'noshowplot' );
            % save the data and generate cells
            particles=repmat(CellVision3D.Particle3D.empty,1,size(pos,1));
            for i=1:size(pos,1);
                particles(i)=CellVision3D.Particle3D(obj.label,pos(i,:),...
                    obj.numframes,obj.zxr);
            end
            % save particles to itself
            obj.particles=particles;
        end
        
        % fit particles from the certain frame
        run(obj,input)
        
        % view the intial result
        view(obj)
          
    end
    
end

