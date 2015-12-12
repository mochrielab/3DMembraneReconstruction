function [  ] = run(obj,input)
% Yao Zhao 12/11/2015
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
        dispay(['frame processed ',num2str(iframe)])
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