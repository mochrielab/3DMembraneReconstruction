function cells=constructCellsByMembraneParticles(membranes, varargin)
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
    % for each particle set
    for i=1:nargin-1
        particles=varargin{i};
        % for each particle
        peaks=particles.getCentroid;
        % bb xy order in reversed
        [in] = inpolygon(peaks(:,1),peaks(:,2),bb{1}(:,1),bb{1}(:,2));
        in = reshape(in,1,length(in));
        cells(icell).particles=[cells(icell).particles,particles(in)];
    end
    
end


end