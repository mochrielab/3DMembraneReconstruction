function [analysismethods,descriptions,inputformats]=getCellAnalysisMethods()
% get all possible analyze methods
% output possbile analysis methods names, their descriptions and input
% formmats
% 3/26/2016 Yao Zhao

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