function [constructionmethods,descriptions]=getCellConstructionMethods()
% get cell construction methods



constructionmethods=methods(CellVision3D.CellConstructor);
constructionmethods=constructionmethods...
    (cellfun(@(x)~isempty(strfind(x,'constructCellsBy')),constructionmethods));
constructionmethods=['none';constructionmethods];
descriptions=[{'none'}];
for i=1:length(constructionmethods)
    switch constructionmethods{i}
        case 'constructCellsByContourParticles'
            disc='brightfield contours and fluorescent particles inside the cell, need to be updated';
        case 'constructCellsByMembraneParticles'
            disc='fluorescent membranes and fluorescent particles inside the membranes';
        case 'constructCellsByContour'
            disc='only brightfield contours, still in build';
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