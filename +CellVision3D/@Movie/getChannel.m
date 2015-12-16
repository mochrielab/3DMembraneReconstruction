function [ channel ] = getChannel( obj, varargin )
% set channel information for Movie
% 3/21/2015
% Yao Zhao

if nargin==2
    channelname=varargin{1};
    if isa(channelname,'char')
        channelID=(strcmp(channelname,{obj.channels.label}));
    elseif isa(channelname,'numeric')
        channelID=channelname;
    else
        error('unsupported channelname type');
    end
    
    channel=obj.channels(channelID);
elseif nargin ==1
    channel=obj.channels;
end

end

