function [out] = cellfinderbrightfield2Dgui( img,varargin )
%find the cells in bright field
% input: a bright field image
% 3/21/2015 Yao Zhao
% will need a shape desciptor filter later
% randomize shape input

import CellVision3D.*
import CellVision3D.guiselector.*

if nargin==1
    thmax=.3;
    thmin=.1;
elseif nargin==3
    thmax=varargin{1};
    thmin=varargin{2};
else
    error('wrong number of input');
end

img=Image2D.bpass(img,1,0);
% se=strel('disk',10);
% img=img-imopen(img,se);
f0=figure('Position',[50 100 1300 600]);
data=struct('th1',[],'th2',[],'ax',[],'ay',[],'bb',[]);
hdata=hstruct(data);
hdata.data.th1=thmax;
hdata.data.th2=thmin;
hdata.data.ax=axes('Parent',f0,'Units','pixel','Position',[100 0 600 600]);
hdata.data.ay=axes('Parent',f0,'Units','pixel','Position',[700 0 600 600]);

b1=uicontrol('Parent',f0,'Style','slider','Min',0,'Max',1,'Value',hdata.data.th1,...
    'SliderStep',[0.005,0.03],'Position',[10 0 30 600],'Callback',{@plotimagetmp,img,'th1',hdata});
b2=uicontrol('Parent',f0,'Style','slider','Min',0,'Max',1,'Value',hdata.data.th2,...
    'SliderStep',[0.005,0.03],'Position',[50 0 30 600],'Callback',{@plotimagetmp,img,'th2',hdata});
plotimagetmp([],[],img,[],hdata);
waitfor(f0);

out.boundaries=hdata.data.bb;
out.thmax=hdata.data.th1;
out.thmin=hdata.data.th2;
end

function plotimagetmp(hObj,event,img,field,hdata)

if strcmp(field,'th2')
    hdata.data.th2=(get(hObj,'Value'));
elseif strcmp(field,'th1')
    hdata.data.th1=(get(hObj,'Value'));
end

if hdata.data.th2>=hdata.data.th1
    hdata.data.th2=hdata.data.th1-0.0001;
end
%%
th2=hdata.data.th2;
th1=hdata.data.th1;
bw=edge(img,'canny',[th2,th1]);
bw=bwmorph(bw,'bridge');
se=strel('disk',5);
% bw2=imdilate(bw,se);
bw2=bw;
bwn=bwlabel(1-bw2,4);

axes(hdata.data.ax);cla;
imagesc(bwn);axis image;colormap gray;axis off;
axes(hdata.data.ay);cla;
p=regionprops(bwn,'Area','Eccentricity','MajorAxisLength',...
    'MinorAxisLength','PixelIdxList','Centroid','Perimeter');
as=[p.Area];
ps=[p.Perimeter]./sqrt(as);
la=[p.MajorAxisLength];
sa=[p.MinorAxisLength];
es=[p.Eccentricity];
cnts=[p.Centroid;];
xs=cnts(1:2:end);
ys=cnts(2:2:end);

% choose
imagesc(img);axis image;colormap gray; axis off;hold on;
choose = as>600 & as<10000 &...
    xs> 20 & ys>20 & ...
    xs< size(img,2)-20 & ys<size(img,1)-20 & ps<6 &...
   sa>10 & sa<40 & la>40 ;%& ps<3 ;%& es>.2; %sa < 60 & 
p=p(choose);
bb=[];
for i=1:length(p)
    bw4=zeros(size(bwn));
    bw4(p(i).PixelIdxList)=1;
    bw4=imclose(bw4,se);
    bbt=bwboundaries(bw4);
    bb{i}=[bbt{1}(:,2),bbt{1}(:,1)];
end
for i=1:length(bb)
    plot(bb{i}(:,1),bb{i}(:,2),'LineWidth',2);hold on;
end
hdata.data.bb=bb;

end

