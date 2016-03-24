function [ cells ] = constructCellsByParticles( varargin )
% construct array of cells only by particles
% find nearby particles and group them together to form cells

%%
numParticleChannels = length(varargin);


% group all cells together

% for each particle set
peaks=[];
allparticles=[];
for i=1:numParticleChannels
    particles=varargin{i};
    % for each particle channel append peaks, add channel label
    tmp=particles.getCentroid;
    peaks=[peaks;tmp,zeros(size(tmp,1),1)+i];
    allparticles = [allparticles;particles];
end


% get the cell radius
zxr=particles(1).getParam('zxr');
th = CellVision3D.Math.Geometry.getPointsClusterSize(peaks(:,1:3),zxr);


% group the cells
[groups] = CellVision3D.Math.Geometry.groupPoints...
    (peaks(:,1:3),th,'distance from center',zxr);


% construct cells
numcell=length(groups);
cells=repmat(CellVision3D.Cell.empty,1,numcell);
% for each cell
for icell=1:numcell
    cells(icell)=CellVision3D.Cell();
    cells(icell).particles=allparticles(groups{icell});
end


% plot grouped result
if 0
    colors=hsv(length(groups));
    for igroup=1:length(groups)
        gpind=groups{igroup};
        plot(peaks(gpind,2),peaks(gpind,1),'o-','color',colors(igroup,:));hold on;
    end
end
end
