function [ obj ] = FirstFrameParticle( obj, id, varargin )
% get particles for the first frame
% 3/22/2015
% Yao Zhao


%%

if isa(id,'char')
    id=find(strcmp(id,obj.channelnames));
elseif isa(id,'numeric')
else
    error('unsupported channelname type');
end
% get first channel image
proj=obj.GrabProjection(id,1);
img=obj.GrabImage3D(id,1);
% if image is particle type
if strcmp(obj.channeltypes{id},'fp')
    img=img-ImgTh(img(:),.5);
    img(img<0)=0;
    bimg=bpass3(img,obj.particleparam.lnoise,...
        obj.particleparam.lobject,obj.zxr);
%     sortbimg=sort(bimg(:),'descend');
    bimg=bimg/max(bimg(:));
    pk=pkfnd3(bimg,obj.particleparam.peakthreshold,...
        obj.particleparam.lobject);
    
end
bordercut=obj.particleparam.bordercut;
pk=pk(pk(:,1)>bordercut(1) & pk(:,1)<obj.sizeX-bordercut(1) & ...
    pk(:,2)>bordercut(2) & pk(:,2)<obj.sizeY-bordercut(2) & ...
    pk(:,3)>bordercut(3) & pk(:,3)<obj.sizeZ-bordercut(3),:);
obj.particle_ff.(obj.channelnames{id}).peaks=pk;
obj.particle_ff.(obj.channelnames{id}).type='centroid';

for i=1:nargin-2
    if strcmp(varargin{i},'showplot')
        SI(proj);hold on;
        plot(pk(:,1),pk(:,2),'or');
    end
end

end

