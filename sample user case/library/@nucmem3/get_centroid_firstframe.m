function nm=get_centroid_firstframe(nm)
%get the centroid of each nuclei in the first frame, for 3d analysis

%% get the frame 
iframe=1;
pimg=nm.grab(iframe,nm.focusplane);
% SE1=strel('disk',10);
% SE2=strel('disk',2);
% bimg1=pimg-imopen(pimg,SE1);
bimg=pimg;
% bimg=bpass(pimg,.5,5);
% SI(bimg,pimg)
%% gui interface
f0=figure('Position',[50 50 900 750]);
f1=uicontrol('Parent',f0,'Style','slider','Min',0,'Max',1,'Value',nm.th,...
    'Position',[10 10 40 730],'Callback',{@filterednuclei,[],nm,bimg});
f2=axes('Parent',f0,'Units','pixel','Position',[120 50 700 700]);
filterednuclei(f1,[],[],nm,bimg)
waitfor(f0);
display(['filtering threshold ',num2str(nm.th), ' selected.'])
display([num2str(nm.num_nuc), ' nuclei found.'])
end

% get centroid of nuclei from the first frame
function []=filterednuclei(hObj,event,f2,nm,bimg)
%%
wsz=nm.wsize;
hw=(wsz-1)/2;
nm.th=get(hObj,'Value');
th=nm.th*max(bimg(:));
bw=bimg>th;
bw = imfill(bw,'holes');
% cc=bwconncomp(bw);
props=regionprops(bw,'Area','Centroid','PixelList');

sX=nm.sizeX;
sY=nm.sizeY;
sZ=nm.sizeZ;

cnt=[];
for i=1:length(props)
    area=props(i).Area;
    centroid=props(i).Centroid;
    if area > 200 && centroid(1)>2*hw && centroid(2)>2*hw && centroid(1)<sX-2*hw && centroid(2)<sY-2*hw
        %         plot(centroid(1),centroid(2),'o');
        cnt=[cnt;centroid];
    end
end
if 1
    SI(bw);hold on;
    if ~isempty(cnt)
    DrawCircles(cnt(:,1:2),1,'r',10);
    end
end
cnt=[cnt,zeros(size(cnt,1),1)+(1+nm.numstacks)/2];
nm.cnt_tmp=cnt;
nm.num_nuc=size(nm.cnt_tmp,1);
end
