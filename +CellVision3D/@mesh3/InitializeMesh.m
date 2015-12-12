function [ obj ] = InitializeMesh( obj)
%initialize the mesn from 3d images
% 3/12/2015 Yao Zhao

%% 

% preprocess the image
obj.PreProcessImage;

% calculate the directional laplacian transform of image
% and the eigen values of each surface 
% use it 
[ l1,v1,l2,v2,l3,v3 ] = DirectionalLaplacian( obj.image);

% 3d surface canny detection
[ bw2 ] = NonMaxiumSuppression( l1,l2,l3,v1,obj.cannyth,obj.image);


%% surf extension method
% % surface add points to the surfaces
% for i=1:3
% bw2=bw2+SurfEdge3(bw2,v1,.2);
% end
% 
% 
% % thin the image edge
% [ bw2,L2 ] = bwthin3( bw2,inf);
% obj.bwsurf=bw2;
% obj.L=L2;

% % get isosurface 
% imgiso=bw2+(L2==2)*2;
% imgiso=bpass3(imgiso,1,0,obj.zxr);
% p1=isosurface(imgiso,1);
% p1=reducepatch(p1,.5);

% % correct scale and offset
% p1.vertices=p1.vertices-1;
% p1.vertices(:,3)=p1.vertices(:,3)*obj.zxr;


%% image dilation imfill method
% dilate, fill, erode, sbstract edge
% 3/18/2015
% this
bw3=bw2;
% dilate
se=ones(3,3,3);
for i=1:3
bw3=imdilate(bw3,se);
end

% fill
L=bwlabeln(1-bw3);
bw4=L~=1;

% erode
for i=1:3
    bw4=imerode(bw4,se);
end

% substract edge
obj.bwsurf=bw4-bw2;
L2=ones(size(bw2));
L2(bw2==1)=0;
L2((bw4-bw2)==1)=2;
obj.L=L2;
% get isosurface 
imgiso=bw4*2-bw2-1;
% imgiso=gaussianfilter3(imgiso,1);
imgiso=gaussianfilter3(imgiso,1.5);
% p1=isosurface(imgiso,-0.2);% changed from -0.2 to 0, 6/4/2015
p1=isosurface(imgiso,-0.2);% changed from -0.2 to 0, 6/4/2015
p1=reducepatch(p1,.5);


% correct scale and offset
% p1.vertices=p1.vertices-1;
p1.vertices(:,3)=p1.vertices(:,3)*obj.zxr;


obj.vertices=p1.vertices;
obj.faces=p1.faces;
obj.GetEdgesAndNeighbors;


if obj.diagnostic_mod_on==1
    obj.DiagnoseMeshTopology;
end


% % remove noise of bw2, usually not used
% [ bw2 ] = SurfaceFilter( bw2,v1 );




end

