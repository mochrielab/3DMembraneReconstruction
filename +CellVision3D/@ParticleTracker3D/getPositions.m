function pk=getPositions(obj,zstack,varargin)
% get positions from a single frame
% 11/22/2015 Yao Zhao
bimg=CellVision3D.Image3D.bpass(zstack,obj.lnoise,...
    obj.lobject,obj.zxr);
bimg=bimg/max(bimg(:));
pk=CellVision3D.Image3D.pkfnd(bimg,obj.peakthreshold,...
    obj.lobject);
bordercut=obj.bordercut;
pk=pk(pk(:,1)>bordercut(1) & pk(:,1)<size(zstack,2)-bordercut(1) & ...
    pk(:,2)>bordercut(1) & pk(:,2)<size(zstack,1)-bordercut(1) & ...
    pk(:,3)>obj.bordercutz(1) & pk(:,3)<size(zstack,3)-obj.bordercutz(1),:);

pk(:,4)=zstack(sub2ind(size(zstack),round(pk(:,2)),round(pk(:,1)),round(pk(:,3))));
% decide if show plot
for i=1:nargin-2
    if strcmp(varargin{i},'showplot')
        proj=squeeze(sum(bimg,3));
        imagesc(proj);colormap gray;axis image;hold on;
        plot(pk(:,1),pk(:,2),'or');
    end
end
end
