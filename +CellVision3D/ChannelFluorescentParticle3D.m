
classdef ChannelFluorescentParticle3D < CellVision3D.Channel & CellVision3D.ParticleTracker3D
    % channel for brightfield particles in 3D
    % 11/17/2015 Yao Zhao
    
    properties
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
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% temporarily change
            img(885,960,:)=mean(img(:));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % get cell contours
            pos=obj.getPositions( img,'showplot' );
            % save the data and generate cells
            particles=repmat(CellVision3D.Particle3D.empty,1,size(pos,1));
            for i=1:size(pos,1);
                particles(i)=CellVision3D.Particle3D(obj.label,pos(i,:),...
                    obj.numframes,obj.zxr);
            end
        end
        
        % fit particles from the certain frame
        function run(obj,input)
            if isa(input,'CellVision3D.Cell')
                cells = input;
                for iframe=1:obj.numframes
                    tic
                    % get image
                    img3=obj.grabImage3D(iframe);
                    % for each cell
                    for icell=1:length(cells)
                        % for the particles belong to current channel
                        particles=cells(icell).particles;
                        particles=particles(strcmp(obj.label,{particles.label}));
                        % merge all particle tracks
                        nump=length(particles);
                        pos=zeros(nump,4);
                        for ip=1:nump
                            pos(ip,:)=particles(ip).tmppos;
                        end
                        % fit
                        pos=obj.fitPositions...
                            (img3,pos,'notshowplot');
                        % save result to particles
                        for ip=1:nump
                            particles(ip).addFrame(pos(ip,:),iframe);
                        end
                    end
                    toc
                end
            elseif isa(input,'CellVision3D.Particle')
                 particles = input;
                for iframe=1:obj.numframes
                    tic
                    % get image
                    img3=obj.grabImage3D(iframe);
                    % for each cell
                    % only process particles with the matching label
                    particles=particles(strcmp(obj.label,{particles.label}));
                    for ip=1:length(particles)
                        pos=particles(ip).tmppos;
                        % fit
                        [pos,resnorm]=obj.fitPositions...
                            (img3,pos,'noshowplot');
                        % save result to particles
                        particles(ip).addFrame(pos,iframe,resnorm);
                    end
                    toc
                end
            else
                warning('wrong type');
            end
        end
    end
    
end

