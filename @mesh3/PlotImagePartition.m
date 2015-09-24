function [ obj ] = PlotImagePartition( obj )
%plot the result of image partition


%%
clf
    L=obj.L;
    numc=max(L(:));
    colors=hsv(numc);
        p=isosurface(L==1,.5);
    patch(p,'FaceColor',colors(1,:),'EdgeColor','none','FaceAlpha',.3);hold on;

for i=2:max(L(:))
    p=isosurface(L==i,.5);
    patch(p,'FaceColor',colors(i,:),'EdgeColor','none','FaceAlpha',.3);hold on;
end

if 2<=max(L(:))

legend([{'edge'},cellfun(@(x)['core ',num2str(x)],num2cell(2:max(L(:))),'UniformOutput',0)]);
else
    legend('edge');
end
camlight
lighting gouraud;
axis([1 size(obj.image,2) 1 size(obj.image,1) 1 size(obj.image,3)]);

end
