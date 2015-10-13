function [ img ] = GrabProjection( obj, channelname, iframe )
% get the stack frame of the channel
% 3/21/2015
% Yao Zhao

%%
if isa(channelname,'char')
    channelID=(strcmp(channelname,obj.channelnames));
elseif isa(channelname,'numeric')
    channelID=channelname;
else
    error('unsupported channelname type');
end

if sum(channelID)==0
    error('channel name not found');
else
    img=0;
    for istack=1:obj.numstacks
        img=img+double(obj.mov{channelID}{istack+obj.numstacks*(iframe-1)});
    end
    img=img./obj.illuminationcorrection/obj.numstacks;
end

end

