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
        cells=constructCellsByContour(membranes)
        %
        cells=constructCellsByMembrane(membranes)
        %
        cells=constructCellsByParticles(varargin)
        %
        
        % get cell construction methods
        function [constructionmethods,descriptions]=getCellConstructionMethods()
            constructionmethods=methods(CellVision3D.CellConstructor);
            constructionmethods=constructionmethods...
                (cellfun(@(x)~isempty(strfind(x,'constructCellsBy')),constructionmethods));
            constructionmethods=['none';constructionmethods];
            descriptions=[{'none'}];
            for i=1:length(constructionmethods)
                switch constructionmethods{i}
                    case 'constructCellsByContourParticles'
                        disc='brightfield contours and fluorescent particles inside the cell';
                    case 'constructCellsByMembraneParticles'
                        disc='fluorescent membranes and fluorescent particles inside the membranes';
                    case 'constructCellsByContour'
                        disc='only brightfield contours';
                    case 'constructCellsByMembrane'
                        disc='only fluorescent membrane';
                    case 'constructCellsByParticles'
                        disc='only fluorescent particles';
                    otherwise
                        disc=[];
                end
                if ~isempty(disc)
                    descriptions=[descriptions,{disc}];
                end
            end
        end
    end
    
    
end

