function [ img ] = grabImage( obj, channelname, iframe, istack )
% get the stack frame of the channel
% 3/21/2015
% Yao Zhao

%%
if isa(channelname,'char')
    channelID=(strcmp(channelname,{obj.channels.label}));
elseif isa(channelname,'numeric')
    channelID=channelname;
else
    error('unsupported channelname type');
end

if sum(channelID)==0
    error('channel name not found');
else
    img=double(obj.mov{channelID}{istack+obj.numstacks*(iframe-1)})./obj.illuminationcorrection;
end

end

