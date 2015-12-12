function view(obj)
% view the first frame with the membrane
% Yao Zhao 12/12/2015
iframe=1;
img=obj.grabProjection(iframe);
CellVision3D.Image2D.view(img);
hold on;
bb=obj.contours.getBoundaries();
for i=1:length(bb)
    plot(bb{i}(:,1),bb{i}(:,2),'linewidth',2);hold on;
end


end