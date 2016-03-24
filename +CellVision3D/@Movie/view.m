function [  ] = view( obj,varargin )
% preview movie, also take input of cells and plot together with movie
% 3/24/2016 Yao zhao

% plot preview of movie, merge or not
for ichannel=1:min(3,obj.numchannels)
    if ~strcmp('None',obj.getChannel(ichannel).type)
        img=obj.getChannel(ichannel).grabProjection(1);
        if ichannel==1
            img3=zeros([size(img),3]);
        end
        img3(:,:,ichannel)=(img-min(img(:)))/(max(img(:))-min(img(:)));
    end
end

% plot cells
if nargin >1
    cells = varargin{1};
    if obj.numchannels>1
        cells.view(0,img3);
    else
        cells.view(0,img);
    end
end

end

