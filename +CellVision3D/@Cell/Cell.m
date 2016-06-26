classdef Cell < CellVision3D.HObject & CellVision3D.UserData
    % cell class
    % wrapper for the data of each cell
    % 11/17/Yao
    
    properties
        label % user info
        type % cell type, will be specified by its constructor
        particles % particles for each cell
        contours % contours for each cell, membrane types are included
    end
    
    methods
        % constructor
        function obj=Cell()
        end
        % set contours
        function setContours(obj,contours)
            obj.contours=contours;
        end
        % plot cells
        [  ] = plot(cells,iframe,img )
        % get particle labels
        [ labels ] = getParticleLabels( cells )
        % get contour labels
        [ labels ] = getContourLabels( cells )
        % view the result of cells
        [ ] = view(cells,iframe, image)
        %function
        exportCSV(cells,filename);
        % get centroid of the cells
        cnt = getCentroid(cells);
        
    end
    

end

