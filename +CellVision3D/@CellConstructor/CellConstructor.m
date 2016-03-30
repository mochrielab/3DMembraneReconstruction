classdef CellConstructor < CellVision3D.HObject
    % methods to construct cells based on different types of data inputs
    properties
    end
    
    methods
    end
    
        methods(Static)
        %
        cells=constructCellsByContourParticles(contours, varargin)
        %
        cells=constructCellsByMembraneParticles(membranes, varargin)
        %
%         cells=constructCellsByContour(membranes)
        %
        cells=constructCellsByMembrane(membranes)
        %
        cells=constructCellsByParticles(varargin)
        %
        
        % get cell construction methods
        [constructionmethods,descriptions]=getCellConstructionMethods()
        
    end
    
    
end

