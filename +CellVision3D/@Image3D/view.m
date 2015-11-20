function [  ] = view( wimg3,varargin )
% GUI for showing 3d image with sliding bars
% 1/1/2014
% Yao Zhao

if nargin==1
    mx=[];
elseif nargin==2
    mx=varargin{1};
else
    warning('wrong number of input');
end



wimg3=double(wimg3);
if min(size(wimg3))<=1
    warning('not 3d image');
end
%% gui interface
f0=figure('Position',[50 50 1800 700]);
hdata=struct('x',[],'y',[],'z',[],'ax',[],'ay',[],'az',[]);
hdata.x=1;
hdata.y=1;
hdata.z=1;
hdata.ax=axes('Parent',f0,'Units','pixel','Position',[50 50 500 600]);
hdata.ay=axes('Parent',f0,'Units','pixel','Position',[650 50 500 600]);
hdata.az=axes('Parent',f0,'Units','pixel','Position',[1250 50 500 600]);
h=handle(1);
guidata(h,hdata);
b1=uicontrol('Parent',f0,'Style','slider','Min',1,'Max',size(wimg3,2),'Value',hdata.x,...
    'SliderStep',[1 1]/(size(wimg3,2)-1),'Position',[10 50 30 600],'Callback',{@getslice,wimg3,mx,'x',h});
b2=uicontrol('Parent',f0,'Style','slider','Min',1,'Max',size(wimg3,1),'Value',hdata.y,...
    'SliderStep',[1 1]/(size(wimg3,1)-1),'Position',[610 50 30 600],'Callback',{@getslice,wimg3,mx,'y',h});
b3=uicontrol('Parent',f0,'Style','slider','Min',1,'Max',size(wimg3,3),'Value',hdata.z,...
    'SliderStep',[1 1]/(size(wimg3,3)-1),'Position',[1210 50 30 600],'Callback',{@getslice,wimg3,mx,'z',h});

getslice([],[],wimg3,mx,'x',h);
getslice([],[],wimg3,mx,'y',h);
getslice([],[],wimg3,mx,'z',h);
waitfor(f0);

end

function []=getslice(hObj,event,wimg3,mx,xyz,h)
clims=[min(wimg3(:)),max(wimg3(:))];
hdata=guidata(h);
switch xyz
    case 'x'
        v=round(get(hObj,'Value'));
        set(hObj,'Value',v);
        if ~isempty(v)
        hdata.x=v;
        end
        axes(hdata.ax);cla;
        imagesc(squeeze(wimg3(:,round(hdata.x),:)),clims);colormap gray;axis image;axis off;
        title(['x=',num2str(hdata.x)]);
    case 'y'
        v=round(get(hObj,'Value'));
        set(hObj,'Value',v);
        if ~isempty(v)
        hdata.y=v;
        end
        axes(hdata.ay);cla;
        imagesc(squeeze(wimg3(hdata.y,:,:)),clims);colormap gray;axis image;axis off;
        title(['y=',num2str(hdata.y)]);
    case 'z'
        v=round(get(hObj,'Value'));
        set(hObj,'Value',v);
        if ~isempty(v)
        hdata.z=v;
        end
        axes(hdata.az);cla;
        imagesc(squeeze(wimg3(:,:,hdata.z)),clims);colormap gray;axis image;axis off;
        title(['z=',num2str(hdata.z)]);
        if ~isempty(mx)
            hold on;
            mx1 = mx(round(mx(:,3))==hdata.z,:);
            plot(mx1(:,1),mx1(:,2),'o');
        end
end
guidata(h,hdata);
end

