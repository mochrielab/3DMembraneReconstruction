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
        extractContourMeanRadius(cells,contourchannellabel)        
        % get volume of contour
        extractContourVolume(cells,contourchannellabel)
        % get area of contour
        extractContourArea(cells,contourchannellabel)
        % get relative distance from particle to contour
        extractParticleContourDistanceRelative(cells,particlechannellabel,contourchannellabel)
        % get particle number
        extractParticleNumber(cells, particlechannellabel)
        % get particle intensity
        extractParticleIntensity(cells, particlechannellabel)
        % get particle size
        extractParticleSize(cells, particlechannellabel)
        % get methods info
        [analysismethods,descriptions,inputformats]=getCellAnalysisMethods()
        
        
    end
    
end

