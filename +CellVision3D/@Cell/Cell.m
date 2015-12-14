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

        % get cell construction methods
        function [constructionmethods,descriptions]=getCellConstructionMethods()
            constructionmethods=methods(CellVision3D.Cell);
            constructionmethods=constructionmethods...
                (cellfun(@(x)~isempty(strfind(x,'constructCellsBy')),constructionmethods));
            descriptions=[];
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

