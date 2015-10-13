function [ proj ] = zstack2proj( zstack,varargin )
%convert a 3d zstack to projection image

if nargin ==1
    proj=squeeze(sum(zstack,3));
elseif nargin ==2
    if strcmp(varargin{1},'x')
        proj=squeeze(sum(zstack,2));
        
    elseif strcmp(varargin{2},'y')
        proj=squeeze(sum(zstack,1));
        
    else
        proj=squeeze(sum(zstack,3));
    end
end


end

