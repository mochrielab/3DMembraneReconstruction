function [ out ] = cellfinderfluorescent2Dgui (img,varargin)

% cell finder for fluroescent image
% 3/22/2015
% Yao Zhao
import CellVision3D.guiselector.*

% figure handles
f0=figure('Position',[50 50 1000 750]);
f2=axes('Parent',f0,'Units','pixel','Position',[0 0 750 750]);

% data handle
h=hstruct();
h.data.th=.3;
h.data.ax=f2;
h.data.out=[];

%ui
f1=uicontrol('Parent',f0,'Style','slider','Min',0,'Max',1,'Value',h.data.th,...
    'Position',[760 10 40 700],'Callback',{@filteredblob,img,h,'th'});
txt = uicontrol('Style','text',...
    'Position',[760 700 60 20],...
    'String','threshold');

filteredblob(f1,[],img,h,[]);
waitfor(f0);

out=h.data.out;

end



% get centroid of nuclei from the first frame
function [  ]=filteredblob(hObj,event,img,h,tag)
%%
wsz=31;
hw=(wsz-1)/2;

% decide with value to change
if strcmp(tag,'th')
    h.data.th=get(hObj,'Value');
end

%
th=h.data.th*max(img(:));
bw=img>th;
bw = imfill(bw,'holes');

props=regionprops(bw,'Area','Centroid','PixelIdxList','Eccentricity',...
    'Orientation','MajorAxisLength','MinorAxisLength');
[sY,sX,sZ]=size(img);


cnt=[];
bb=[];
cc=[];
for i=1:length(props)
    area=props(i).Area;
    centroid=props(i).Centroid;
    if area > 20 && centroid(1)>2*hw && centroid(2)>2*hw ...
            && centroid(1)<sX-2*hw && centroid(2)<sY-2*hw ;
        cnt=[cnt;centroid,0,props(i).Orientation,props(i).MajorAxisLength,props(i).MinorAxisLength];
        bw2=zeros(size(bw));
        bw2(props(i).PixelIdxList)=1;
        se1=strel('disk',5);
        bw2=imclose(bw2,se1);
        bbtmp=bwboundaries(bw2);
        bb=[bb;bbtmp(1)];
        cc=[cc,regionprops(bw2,'Area','Centroid','PixelIdxList')];
    end
end

axes(h.data.ax);
CellVision3D.Image2D.view(img);hold on;
if ~isempty(bb)
    %     plot(cnt(:,1),cnt(:,2),'ro');
    for i=1:length(bb)
        plot(bb{i}(:,2),bb{i}(:,1));hold on;
    end
end

h.data.out=cc;


end