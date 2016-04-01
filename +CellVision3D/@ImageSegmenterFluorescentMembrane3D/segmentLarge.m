function ps=segmentLarge(obj,img3,varargin)
% segment an image of large cells
% cells have to be well resoluted
% the image stack has to contain the complete contour of cells
% the image is usually large for complete second derivative calculation
% 3/30/2016 Yao Zhao

lobject = obj.lobject;
lnoise = obj.lnoise;
binxy = obj.binxy;
binz =obj.binz;
zxr = binz/binxy*obj.zxr;
strongedgeth=.4;
weakedgeth=.05;
edgelevel=-0;
gaussianfiltersize=2;

% CellVision3D.Image3D.view(img3);


% proj=squeeze(sum(img3,3));
% proj=CellVision3D.Image2D.bpass(proj,lnoise,lobject);
% proj=proj>0;
% CellVision3D.Image2D.view(proj);
% sg2d = CellVision3D.ImageSegmenterFluorescentMembrane2D...
%     ('lobject',obj.lobject,'lnoise',obj.lnoise);
% out = sg2d.segment(proj);

% img3= channel.grabImage3D(1);
% zxr = channel.zxr/9*4;
% img3=CellVision3D.Image3D.crop(img3,[50 280 30 250 1 size(img3,3)]);

% lobject = 50; % size of cells
% lnoise = .5; % noise of membrane
% binxy =2;
% binz =4;
% strongedgeth=.4;
% weakedgeth=.2;

%% background removal
% bin the image
img3=CellVision3D.Image3D.binning(img3,[binxy,binz]);

% pad image with zeros
% padxy = 5;
% padz = 2;
% img3= padarray(img3,[padxy,padxy,padz],'replicate','both');

% filter image
bimg3=CellVision3D.Image3D.bpass(img3,lnoise,lobject/binxy,zxr );
se=strel('ball',round(lobject/binxy),round(lobject/binz));
bimg3=bimg3./imdilate(bimg3,se);
bimg3=bimg3/max(bimg3(:));
display('3d bandpass filter applied')
if showplot
    CellVision3D.Image3D.view(bimg3);
end

% % remove borders
% bordercut = 0;
% bordercutz = 0;
% bimg3=CellVision3D.Image3D.cleanBorder(bimg3,[bordercut,bordercutz]);


% % 3d surface canny detection
% [bw]=CellVision3D.ImageSegmenterFluorescentMembrane3D...
%     .getEigenSecondDerivativesEdge(bimg3,[.1 .2 .5]);
% CellVision3D.Image3D.view(bw);
%% edge finding in 3d
% 3d canny edge filter
bwedge = CellVision3D.Image3D.edgeCanny(bimg3,[weakedgeth strongedgeth]);
if showplot
    CellVision3D.Image3D.view(bwedge);
end
display('3d edge found')

% %% clean up a little bit
% % create strel
% se = CellVision3D.Image3D.strel('disk',floor(lobject/5/binxy/2),zxr*binz/binxy);
% se = ones([3 3 3]);
% % image close
% bwedge=CellVision3D.Image3D.imdilate(bwedge,se);
% CellVision3D.Image3D.view(bwedge);
%% create iso image
bwout=false(size(bwedge));
bwin=false(size(bwedge));
bwedge2=false(size(bwedge));
se = strel('disk',round(floor(lobject/binxy/2)));
se2 = strel('disk',round(floor(lobject/binxy)/2/3));
objsize = pi*(lobject/binxy/2)^2;
hwz = (size(se.getnhood,1)-1)/2;
for istack=1:size(bwedge,3)
    % find outside
    bw2 = imdilate(bwedge(:,:,istack),se,'full');
    bw2 = imfill(bw2,'holes');
    bw2 = imerode(bw2,se);
    bw2 = bw2(1+hwz:end-hwz,1+hwz:end-hwz);
    bwout(:,:,istack)=~bw2;
    
    % find inside
    bw2 = imdilate(bwedge(:,:,istack),se2);
    bw2 = imfill(bw2,'holes');
    bw2 = bwareaopen(bw2,round(objsize/4),4);
    bwin(:,:,istack)=bw2;
    
    % expand edge
    bwedge2(:,:,istack)=imdilate(bwedge(:,:,istack),se2);
end
% set imageiso
imgiso=zeros(size(bwedge));
imgiso(bwout)=-1;
imgiso(bwin)=1;
imgiso(bwedge2) = edgelevel;
imgiso=CellVision3D.Image3D.applyFilterGaussian(imgiso,gaussianfiltersize);
display('iso map build')
if showplot 
    CellVision3D.Image3D.view(imgiso);
end
%% generate patch
p1=isosurface(imgiso,0);
p1=reducepatch(p1,.5);
if showplot
CellVision3D.Patch.view(p1,'r','k',.5,.5);
p2=isosurface(bimg3,0.3);
p2=reducepatch(p2,.5);
CellVision3D.Patch.view(p2,'b','k',.5,.5);
camlight
daspect([1 1 1/zxr])
end
p=CellVision3D.Patch(p1);
p.optimizeMesh;
display('mesh optimised')

%% split patches
ps=p.splitPatch;
colors=hsv(length(ps));
for i=1:length(ps)
    ps(i).alignFaceDirection;
    ps(i).scale([binxy,binz]);
    CellVision3D.Patch.view(ps(i),colors(i,:),'k',.5,.5);
end
camlight
daspect([1 1 1/zxr])

display('patch splitted')


end