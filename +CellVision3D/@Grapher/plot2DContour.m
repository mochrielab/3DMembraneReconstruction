function [  ] = plot2DContour( contour, channel, l , varargin )
%PLOT2DCONTOUR Summary of this function goes here
%   input order: iframe, istack

figure('Position',[50 0 400 400]);
axes('Position',[0 0 1 1]);

if length(varargin)>=1
    iframe=varargin{1};
else
    iframe=1;
end

pts=contour.vertices{iframe};
faces=contour.faces{iframe};
% pts = pts .* (ones(size(pts,1),1)*[1 1 contour.zxr]);


if length(varargin)>=2
    istack=varargin{2};
else
    istack=round(mean(pts(:,3)));
end

if length(varargin)>=3
    turnoff=varargin{3};
else
    turnoff=false;
end



[ allcontours,lowerfaces,pts] = ...
    CellVision3D.MeshBuilder3D.getCrossSection( pts,faces,[0 0 1 istack] );


img=channel.grabImage(iframe,istack);
cnt = round(mean(pts,1));
siz = max(pts,[],1)-min(pts,[],1);
hwz = round(max(siz(1:2))*1.2/2);


roi= [cnt(2)-hwz,cnt(2)+hwz,cnt(1)-hwz,cnt(1)+hwz];
wimg = CellVision3D.Image2D.crop(img,roi);
CellVision3D.Image2D.view(wimg); hold on;

rectangle('Position',[size(wimg,1)-l-2 size(wimg,2)-4 l 2],...
    'FaceColor','w'); hold on;

axis off;

if ~turnoff
for icontour=1:length(allcontours)
    plot(allcontours{icontour}(:,1)-roi(3)+1,...
        allcontours{icontour}(:,2)-roi(1) + 1 ...
        ,'r','linewidth',2);
end
end



end

