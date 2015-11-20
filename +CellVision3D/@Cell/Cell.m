classdef Cell < CellVision3D.HObject 
    % cell class
    % wrapper for the data of each cell
    % 11/17/Yao
    
    properties
        label
        particles
        membranes
        contours
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
    end
    
    methods(Static)
        cells=constructCellsByContoursParticles(contours, varargin)
    end
end

