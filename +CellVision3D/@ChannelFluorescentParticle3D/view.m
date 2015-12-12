function view(obj)
% view the intial result
% 11/17/2015 Yao Zhao

iframe=1;
% get image
img=obj.grabProjection(iframe);
CellVision3D.Image2D.view(img);
hold on;
for ip=1:length(obj.particles)
    cnt=obj.particles(ip).getCentroid;
    plot(cnt(1),cnt(2),'or');
end
end