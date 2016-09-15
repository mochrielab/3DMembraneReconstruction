function [analysismethods,descriptions,inputformats]=getCellAnalysisMethods()
% get all possible analyze methods
% output possbile analysis methods names, their descriptions and input
% formmats
% 3/26/2016 Yao Zhao
% Updated 6/7/16 Jessica Johnston

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
            inputformat={'FluorescentParticle3D','FluorescentMembrane3D'};
        case 'extractParticleParticleDistance'
            disc='caclulate particle to particle distance between two channels';
            inputformat={'FluorescentParticle3D','FluorescentParticle3D'};
        case 'extractContourMeanRadius'
            disc='calculate mean radius of contour';
            inputformat={'FluorescentMembrane3D'};
        case 'extractContourVolume'
            disc='calculate contour volume (microns^3)';
        case 'extractContourArea'
            disc='calculate contour area (microns^2)';
            inputformat={'FluorescentMembrane3D'};
        case 'extractParticleContourDistanceRelative'
            disc='calculate the relative distance between particle and contour';
            inputformat={'FluorescentParticle3D','FluorescentMembrane3D'};
        case 'extractParticleNumber'
            disc='calculate the number of particles';
            inputformat={'FluorescentParticle3D'};        
        case 'extractParticleIntensity'
            disc='calculate the intensity of particles';
            inputformat={'FluorescentParticle3D'};
        case 'extractParticleSize'
            disc='calculate the size of particles';
            inputformat={'FluorescentParticle3D'};
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