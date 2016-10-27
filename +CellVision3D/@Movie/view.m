function [  ] = view( obj,varargin )
% preview movie, also take input of cells and plot together with movie
% input: movie, cells(optional) iframe(optional)
% 3/24/2016 Yao zhao

% plot preview of movie, merge or not
for ichannel=1:min(3,obj.numchannels)
    img=obj.getChannel(ichannel).grabProjection(1);
    if ichannel==1
        img3=zeros([size(img),3]);
    end
    if ~strcmp('None',obj.getChannel(ichannel).type)    
        img3(:,:,ichannel)=(img-min(img(:)))/(max(img(:))-min(img(:)));
    end
end

iframe =0;
if length(varargin) >= 2
    iframe = varargin{2};
end

% plot cells
linelength = 10;
if nargin >1
    cells = varargin{1};
    if obj.numchannels>1
        cells.view(iframe,img3);
    else
        cells.view(iframe,img);
    end
    cnt = cells.getCentroid();
    for i=1:size(cnt,1)
        plot(cnt(i,1)+[0,linelength],cnt(i,2)+[0,linelength],'w');
        text(cnt(i,1)+linelength,cnt(i,2)+linelength,num2str(i),...
            'color','w','FontSize',10);
    end
end

end

