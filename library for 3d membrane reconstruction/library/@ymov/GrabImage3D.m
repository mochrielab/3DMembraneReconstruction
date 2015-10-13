function [ img ] = GrabImage3D( obj, channelname, iframe)
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
    img=zeros(obj.sizeY,obj.sizeX,obj.sizeZ);
    for istack=1:obj.numstacks
        img(:,:,istack)=double(obj.mov{channelID}{istack+obj.numstacks*(iframe-1)})./obj.illuminationcorrection;
    end
end

end

