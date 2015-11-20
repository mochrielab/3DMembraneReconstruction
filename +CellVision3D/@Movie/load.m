function [ obj ]=load(obj,varargin)
%load movie 
% 3/21/2015
% Yao Zhao

if ~exist(obj.filein,'file')
    warning('invalid movie data path');
else
    
    
    % ui select
    if nargin==1
        data=bfopen(obj.filein);
    else
        data=bfopenSelect(obj.filein,varargin{1});
    end
    % load
    mov=data{1}(:,1);
%     obj.fformat=data{1}(:,2);
    % meta data
    omeMeta1=data{4};
%     obj.omeMeta=omeMeta1;
    obj.pix2um=omeMeta1.getPixelsPhysicalSizeY(0).getValue();
    obj.vox2um=omeMeta1.getPixelsPhysicalSizeZ(0).getValue();
    obj.sizeX=omeMeta1.getPixelsSizeX(0).getValue();
    obj.sizeY=omeMeta1.getPixelsSizeY(0).getValue();
    obj.sizeZ=omeMeta1.getPixelsSizeZ(0).getValue();
    obj.numstacks=obj.sizeZ;
    obj.numframes=omeMeta1.getPixelsSizeT(0).getValue();
    
    
    for ichannel=1:obj.numchannels
        chooseind=mod(floor((0:length(mov)-1)/obj.numstacks),obj.numchannels)==ichannel-1;
        obj.channels(ichannel).load(mov(chooseind),obj);
    end
    
end


end