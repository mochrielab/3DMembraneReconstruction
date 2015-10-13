function [ obj ] = FirstImageContourFluo( obj, tag, id )
% process the first image
% extract blob contour information from fluorescent image
% tag decides which kind to use, movie or picture
% id is the id of movie or picture
% result depend on window size
% 3/22/2015
% Yao Zhao

% % check special cases
% for i=1:nargin-3
%     if strcmp(varargin{i},fp)
% end


if strcmp(tag,'moviechannel');
    if isa(id,'char')
        id=find(strcmp(id,obj.channelnames));
    elseif isa(id,'numeric')
    else
        error('unsupported channelname type');
    end
    % get first channel image
    img=obj.GrabProjection(id,1);
    
% if image is particle type
    if strcmp(obj.channeltypes{id},'fp')
        %preprocess
        cutoffth=ImgTh(img,.99);
        img(img>cutoffth)=cutoffth;
        img=bpass(img,.5,0);
        se=strel('disk',20);
        img=img-imopen(img,se);
    end
    
    CellFinderFluo(img);
else
    error('tag type not supported');
end



end
