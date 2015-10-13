function [ obj ]=LoadMovie(obj,varargin)
%load dv movie for ymov class
% 3/21/2015
% Yao Zhao

%%
global datapath;
global codepath;
% javaaddpath(fullfile('codepath',''));

if ~exist(obj.filein)
    warning('invalid dv movie data path');
else
    
    % search for illumination
    pathtmp=fullfile(codepath);
%     pathtmp=pathtmp(1:end-1);
    pathtmp=(fullfile(pathtmp,'\library\data\illumination.mat'));
    if ~exist(pathtmp)
        warning('can not find illumination file');
    end
    
    % ui select
    if nargin==1
        data=bfopen(obj.filein);
    else
        data=bfopenSelect(obj.filein,varargin{1});
    end
    % load
    mov=data{1}(:,1);
    obj.fformat=data{1}(:,2);
    % meta data
    omeMeta1=data{4};
    obj.omeMeta=omeMeta1;
    obj.pix=omeMeta1.getPixelsPhysicalSizeX(0).getValue();
    obj.vox=omeMeta1.getPixelsPhysicalSizeZ(0).getValue();
    obj.sizeX=omeMeta1.getPixelsSizeX(0).getValue();
    obj.sizeY=omeMeta1.getPixelsSizeY(0).getValue();
    obj.sizeZ=omeMeta1.getPixelsSizeZ(0).getValue();
    obj.numstacks=obj.sizeZ;
    obj.numframes=omeMeta1.getPixelsSizeT(0).getValue();
    
    % add illumination
    if ~exist(pathtmp)
        obj.illuminationcorrection=ones(obj.sizeY,obj.sizeX);
    else
        load(pathtmp);
        obj.illuminationcorrection=illumination;
    end
    
    
    for ichannel=1:obj.numchannels
        chooseind=mod(floor((0:length(mov)-1)/obj.numstacks),obj.numchannels)==ichannel-1;
        %         obj.mov{ichannel}=cellfun(@(x)double(x)./obj.illuminationcorrection,mov(chooseind),...
        %             'UniformOutput',0);
        obj.mov{ichannel}=mov(chooseind);
    end
    
    if isempty(obj.endframe)
        obj.endframe=obj.numframes;
    end
end


end