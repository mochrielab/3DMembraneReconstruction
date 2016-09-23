function [  ] = run(obj,input,varargin)
% run the analysis
% Yao Zhao 12/11/2015

%%
if isa(input,'CellVision3D.Cell')
    cells = input;
    for iframe=1:obj.numframes
        tic
        % get image
        img3=obj.grabImage3D(iframe);
        % for each cell
        numcells=length(cells);
        for icell=1:numcells
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
            if nargin>3
                [pos,resnorm]=obj.fitPositions...
                    (img3,pos,'showplot',1,'parent',varargin{2});
            else
                [pos,resnorm]=obj.fitPositions...
                    (img3,pos);
            end
            % save result to particles
            for ip=1:nump
                particles(ip).addFrame(iframe,pos(ip,:),resnorm);
            end
            % call back function
            if nargin>2
                if ~isempty(varargin{1})
                    varargin{1}(((iframe-1)*numcells+icell)/(obj.numframes)/numcells);
                end
            end
        end
        display(['frame processed ',num2str(iframe)])
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
        numcells=length(particles);
        for ip=1:length(particles)
            pos=particles(ip).tmppos;
            % fit
            if nargin>3
                [pos,resnorm]=obj.fitPositions...
                    (img3,pos,'showplot',1,'parent',varargin{2});
            else
                [pos,resnorm]=obj.fitPositions...
                    (img3,pos);
            end
            % save result to particles
            particles(ip).addFrame(iframe,pos,resnorm);
            % call back function
            if nargin>2
                varargin{1}(((iframe-1)*numcells+ip)/(obj.numframes)/numcells);
            end
        end
        display(['frame processed ',num2str(iframe)])
        toc
    end
else
    warning('wrong type');
end


end

