function run(obj,input)
% fit cells from the certain frame
% Yao Zhao 12/11/2015
if isa(input,'CellVision3D.Contour3D')
    contours=input;
    % create cell contours based on the segmentation
    [vertices,faces,edges,neighbors] = obj.generateMeshSphere(3);
    for iframe=[1,1,1:obj.numframes]
        tic
        % get image
        image3=obj.grabImage3D(iframe);
        % for the contours belong to current channel
        contours=contours(strcmp(obj.label,{contours.label}));
        % for each cell
        for icell=1:length(contours)
            % fit
            initialpos=contours(icell).tmpvertices;
            [outputpos] = obj.fitMesh(image3,initialpos,vertices,faces,edges,neighbors,...
                'noshowplot');
            contours(icell).addFrame(iframe,outputpos,faces);
        end
        toc
    end
elseif isa(input,'CellVision3D.Cell')
    cells=input;
    % create cell contours based on the segmentation
    [vertices,faces,edges,neighbors] = obj.generateMeshSphere(3);
    for iframe=[1,1,1:obj.numframes]
        tic
        % get image
        image3=obj.grabImage3D(iframe);
        % for the contours belong to current channel
        contours=[cells.membranes];
        contours=contours(strcmp(obj.label,{contours.label}));
        % for each cell
        for icell=1:length(contours)
            % fit
            initialpos=contours(icell).tmpvertices;
            [outputpos] = obj.fitMesh(image3,initialpos,vertices,faces,edges,neighbors,...
                'showplot');
            % save result
            contours(icell).addFrame(iframe,outputpos,faces);
        end
        toc
    end
end


end