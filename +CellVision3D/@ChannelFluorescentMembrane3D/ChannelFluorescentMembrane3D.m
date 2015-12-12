
classdef ChannelFluorescentMembrane3D < CellVision3D.Channel ...
        & CellVision3D.MeshBuilder3DSphere & ...
        CellVision3D.ImageSegmenterFluorescentMembrane3DSphere
    % channel for spherical fluroescent membranes
    % 11/17/2015 Yao Zhao
    
    properties
        contours
        out
    end
    
    methods
        % constructor
        function obj=ChannelFluorescentMembrane3D(label,type)
            obj@CellVision3D.Channel(label,type);
        end
        
        % generate cells from the a selected frame
        function contours=init(obj,iframe)
            % get image stack
            image3=obj.grabImage3D(iframe);
            %             % create a fluorescent 3d image segmenter
            %             sg=CellVision3D.ImageSegmenterFluorescentMembrane3DSphere();
            % segment the image
            out=obj.segment(image3,'noshowplot');
            % create cell contours based on the segmentation
            %             [points,faces,edges,neighbors] = CellVision3D...
            %                 .MeshBuilder3DSphere.generateMeshSphere(3);%
            [points,faces,edges,neighbors] = obj.generateMeshSphere(3);
            % initialize contours
            contours=repmat(CellVision3D.Contour3D.empty,1,length(out));
            % assign values for each contour
            for i=1:length(out)
                contours(i)=CellVision3D.Contour3D(obj.label,obj.numframes,...
                    points*sqrt(out(i).Area/pi).*...
                    (ones(size(points,1),1)*[1 1 1/obj.zxr])+...
                    ones(size(points,1),1)*out(i).Centroid,...
                    faces,obj.zxr);
            end
            % save contours to it self
            obj.contours=contours;
            obj.out=out;
        end
        
        % fit cells from the certain frame
        function run(obj,input)
            if isa(input,'CellVision3D.Contour3D')
                contours=input;
                % create mesh builder
                meshbuilder=CellVision3D.MeshBuilder3DSphere(obj.zxr);
                % create cell contours based on the segmentation
                [vertices,faces,edges,neighbors] = CellVision3D...
                    .MeshBuilder3DSphere.generateMeshSphere(3);
                for iframe=[1,1,1,1,1:obj.numframes]
                    tic
                    % get image
                    image3=obj.grabImage3D(iframe);
                    % for each cell
                    for icell=1%:length(contours)
                        % for the contours belong to current channel
                        contours=contours(strcmp(obj.label,{contours.label}));
                        % fit
                        initialpos=contours(icell).tmpvertices;
                        [outputpos] = meshbuilder...
                            .fitMesh(image3,initialpos,vertices,faces,edges,neighbors,...
                            'noshowplot');
                        contours(icell).setVertices(outputpos,iframe);
                        contours(icell).setFaces(faces,iframe);
                    end
                    toc
                end
            end
        end
        
        % view the first frame with the membrane
        function view(obj)
            iframe=1;
            img=obj.grabProjection(iframe);
            CellVision3D.Image2D.view(img);
            hold on;
            for i=1:length(obj.out)
                bw=zeros(size(img));
                bw(obj.out(i).PixelIdxList)=1;
                bb=bwboundaries(bw);
                plot(bb{1}(:,2),bb{1}(:,1),'linewidth',2);hold on;
            end
        end
        
    end
    
end

