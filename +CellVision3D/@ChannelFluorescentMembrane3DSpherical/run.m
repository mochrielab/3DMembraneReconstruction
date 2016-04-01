function run(obj,input,varargin)
% fit cells from the certain frame
% varargin{1} accept call back function to excute at the end of each cycle
% Yao Zhao 12/11/2015

if ~isempty(input) %% if input is not empty
    
    if isa(input,'CellVision3D.Contour3D')
        contours=input;
        % create cell contours based on the segmentation
        [vertices,faces,edges,neighbors] = obj.generateMeshSphere(obj.ndivision);
        index=0;
        for iframe=[1,1,1:obj.numframes]
            tic
            % get image
            image3=obj.grabImage3D(iframe);
            % for the contours belong to current channel
            contours=contours(strcmp(obj.label,{contours.label}));
            % for each cell
            numcells=length(contours);
            for icell=1:length(contours)
                % fit
                initialpos=contours(icell).tmpvertices;
                if length(varargin)>1
                    [outputpos] = obj.fitMesh(image3,initialpos,vertices,faces,edges,neighbors,...
                        'showplot',1,'Parent',varargin{2});
                else
                    [outputpos] = obj.fitMesh(image3,initialpos,vertices,faces,edges,neighbors);
                end
                contours(icell).addFrame(iframe,outputpos,faces);
                % call back function
                if nargin>2
                    varargin{1}(index/(3+obj.numframes)/numcells);
                    index=index+1;
                end
            end
            toc
        end
    elseif isa(input,'CellVision3D.Cell')
        cells=input;
        % create cell contours based on the segmentation
        [vertices,faces,edges,neighbors] = obj.generateMeshSphere(obj.ndivision);
        index=0;
        %% pre runs
        iframe=1;
        for ii=[1,1,2]
            tic
            % get image
            image3=obj.grabImage3D(iframe);
            % for the contours belong to current channel
            contours=[cells.contours];
            contours=contours(strcmp(obj.label,{contours.label}));
            % for each cell
            numcells=length(contours);
            for icell=1:length(contours)
                % get the radius of the cell
                pts = contours(icell).tmpvertices;
                r= mean(sqrt(sum((pts-ones(size(pts,1),1)*mean(pts,1)).^2,2)));
                factor = max(round(r/10/ii),1);
                % fit
                initialpos=contours(icell).tmpvertices;
                if length(varargin)>1
                    [outputpos] = obj.fitMesh(...
                        image3,initialpos,vertices,faces,edges,neighbors,...
                        'showplot',1,'Parent',varargin{2},'scale',factor);
                else
                    [outputpos] = obj.fitMesh(...
                        image3,initialpos,vertices,faces,edges,neighbors,...
                        'scale',factor);
                end
                % save result
                contours(icell).addFrame(iframe,outputpos,faces);
                % call back function
                if nargin>2
                    if ~isempty(varargin{1})
                        
                        varargin{1}(index/(3+obj.numframes)/numcells);
                        index=index+1;
                    end
                end
            end
            toc
            
        end
        %% final runs
        for iframe=[1,1:obj.numframes]
            tic
            % get image
            image3=obj.grabImage3D(iframe);
            % for the contours belong to current channel
            contours=[cells.contours];
            contours=contours(strcmp(obj.label,{contours.label}));
            % for each cell
            numcells=length(contours);
            for icell=1:length(contours)
                % fit
                initialpos=contours(icell).tmpvertices;
                if length(varargin)>1
                    [outputpos] = obj.fitMesh(image3,initialpos,vertices,faces,edges,neighbors,...
                        'showplot',1,'Parent',varargin{2});
                else
                    [outputpos] = obj.fitMesh(image3,initialpos,vertices,faces,edges,neighbors);
                end
                % save result
                contours(icell).addFrame(iframe,outputpos,faces);
                % call back function
                if nargin>2
                    if ~isempty(varargin{1})
                        
                        varargin{1}(index/(3+obj.numframes)/numcells);
                        index=index+1;
                    end
                end
            end
            toc
        end
    end
    
end

end