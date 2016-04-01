function [  ] = plot3DZ( contour,varargin  )
%PLOT3DZ Summary of this function goes here
%   Detailed explanation goes here

if length(varargin)>=1
    iframe=varargin{1};
else
    iframe=1;
end

%% 3d
zxr=contour.zxr;
p.vertices=contour.vertices{iframe}...
    .*(ones(size(contour.vertices{iframe},1),1)*[1 1 zxr]);
p.faces=contour.faces{iframe};
v=p.vertices;
wz=round(max(sqrt(sum((v-ones(size(v,1),1)*mean(v,1)).^2,2)))*1.3);
txtwz=wz*.9;
cnt=mean(p.vertices,1);
p.vertices=v-ones(size(v,1),1)*mean(v,1);
figure('Position',[50 0 400 400]);
axes('Unit','Normalized','Position',[0 0 1 1]);

patch(p,...
    'FaceColor','r','FaceAlpha',.5,'EdgeColor','none');
axis([-wz,wz,-wz,wz,-wz,wz])
% text(0,txtwz,0,'z direction');
view([0 0 -1])

camlight
lighting gouraud;
axis off;
CellVision3D.Grapher.format(gcf)




end

