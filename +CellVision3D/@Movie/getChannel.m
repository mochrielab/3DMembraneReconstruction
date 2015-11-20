function [ channel ] = getChannel( obj, channelname )
% set channel information for Movie
% 3/21/2015
% Yao Zhao

if isa(channelname,'char')
    channelID=(strcmp(channelname,{obj.channels.label}));
elseif isa(channelname,'numeric')
    channelID=channelname;
else
    error('unsupported channelname type');
end

channel=obj.channels(channelID);

end

