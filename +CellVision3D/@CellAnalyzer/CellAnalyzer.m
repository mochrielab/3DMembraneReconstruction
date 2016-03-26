classdef CellAnalyzer < CellVision3D.HObject
    % collection of methods to analyze cells'
    % 3/26/2016 Yao Zhao
    
    
    properties
    end
    
    methods
        % constructor
        function obj=CellAnalyzer()
        end
    end
    
    
    methods (Static)
        % get distance between a pair of particles
        extractParticlePairDistance(cells,channellabel)
        % get distance between particles and cell contour
        extractParticleContourDistance(cells,particlechannellabel,contourchannellabel)
        % get distance between particles
        extractParticleParticleDistance(cells,channellabel)
        
        % get all possible analyze methods
        function [analysismethods,descriptions,inputformats]=getCellAnalysisMethods()
            analysismethods=methods(CellVision3D.CellAnalyzer);
            analysismethods=analysismethods...
                (cellfun(@(x)~isempty(strfind(x,'extract')),analysismethods));
            analysismethods=['none';analysismethods];
            descriptions=[{'none'}];
            inputformats=[{[]}];
%             descriptions=[];
            for i=1:length(analysismethods)
                switch analysismethods{i}
                    case 'extractParticlePairDistance'
                        disc='calculate distance between two particles in the same channel';
                        inputformat={'FluorescentParticle3D'};
                    case 'extractParticleContourDistance'
                        disc='calculate the distance between particles and contour';
                        inputformat={'FluorescentMembrane3D','FluorescentParticle3D'};
                    case 'extractParticleParticleDistance'
                        disc='caclulate particle to particle distance between two channels';
                        inputformat={'FluorescentParticle3D','FluorescentParticle3D'};
                    otherwise
                        disc=[];
                        inputformat=[];
                end
                if ~isempty(disc)
                    descriptions=[descriptions,{disc}];
                    inputformats=[inputformats,{inputformat}];
                end
            end
        end
        
    end
    
end

