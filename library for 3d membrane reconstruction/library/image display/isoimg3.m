function []=isoimg3(th,zxr,varargin)
% plot iso 3d image, threshold, zxr ration, and images
% isoimg3(th,zxr,varargin)

tn=nargin-2;
m=ceil(sqrt(tn));
n=ceil(tn/m);

for i=1:m*n
    subplot(n,m,i)
    v=varargin{i};
    pat=patch(isosurface(v,th*max(v(:))),'FaceColor','red','EdgeColor','none');
    isonormals(v,pat);
    daspect([1,1,1/zxr])
    view(3);
    axis([1 size(v,1) 2 size(v,2) 3 size(v,3)])
    camlight
    lighting gouraud
end

end