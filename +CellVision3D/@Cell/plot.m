function [  ] = plot(cells,iframe,img )
%plot cells

if ~isempty(img)
    imagesc(img);colormap gray;axis image;hold on;
end

labels=cells.getParticleLabels;
colors=hsv(length(labels)+1);
for icell=1:length(cells)
    bb=cells(icell).contours(1).getBoundaries(iframe);
    plot(bb{1}(:,1),bb{1}(:,2),'LineWidth',2,'Color',colors(end,:));hold on;
    cnt=cells(icell).particles.getCentroid(iframe);
    labeltmp={cells(icell).particles.label};
    for i=1:size(cnt,1)
        plot(cnt(i,1),cnt(i,2),'o','LineWidth',2,'Color',colors(strcmp(labeltmp{i},labels),:));hold on;
    end
end


end

