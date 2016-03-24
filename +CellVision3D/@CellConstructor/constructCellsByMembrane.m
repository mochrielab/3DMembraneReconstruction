function cells=constructCellsByMembrane(membranes)
% construct array of cells by the contour
% merge different particle types together

% initalizetion
numcell=length(membranes);
cells=repmat(CellVision3D.Cell.empty,1,numcell);

% for each cell
for icell=1:numcell
    cells(icell)=CellVision3D.Cell();
    cells(icell).contours=membranes(icell);
    bb=membranes(icell).getBoundaries(0);
end

end