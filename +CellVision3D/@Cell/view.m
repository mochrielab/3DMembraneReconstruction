function [ ] = view(cells,iframe, image)
% plot the result of the cells
% 3/22/2016

% choose between 2d and 3d plots
if ~isempty(image)
    if length(size(image))==2
        imagesc(image);colormap gray;axis image;hold on;
    elseif length(size(image))==3
        imagesc(image);axis image;hold on;
    end
end
axis off;

% get all labels and assign color
particlelabels=cells.getParticleLabels;
numparticlelabels=length(particlelabels);
contourlabels=cells.getContourLabels;
colors=hsv(length(particlelabels)+length(contourlabels));

% plot each cell
for icell=1:length(cells)
    % num of contours
    numcontours=length(cells(icell).contours);
    % plot each contour
    for ii=1:numcontours
        % get label for this contour
        labeltmp=cells(icell).contours(ii).label;
        bb=cells(icell).contours(ii).getBoundaries(iframe);
        plot(bb{1}(:,1),bb{1}(:,2),'LineWidth',2,...
            'Color',colors(numparticlelabels+find(strcmp(labeltmp,contourlabels)),:));
        hold on;
    end
    % plot for each particles
    if ~isempty(cells(icell).particles)
        cnt=cells(icell).particles.getCentroid(iframe);
        labeltmp={cells(icell).particles.label};
        for i=1:size(cnt,1)
            plot(cnt(i,1),cnt(i,2),'o','LineWidth',2,'Color',colors(strcmp(labeltmp{i},particlelabels),:));hold on;
        end
        plot(cnt(:,1),cnt(:,2),'-','LineWidth',1.5,'Color','w');hold on;
    end
end

end

