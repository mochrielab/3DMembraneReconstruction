function contours=init(obj,iframe)
% generate cells from the a selected frame
% 12/12/2015 Yao Zhao
% get image stack
image3=obj.grabImage3D(iframe);
%             % create a fluorescent 3d image segmenter
%             sg=CellVision3D.ImageSegmenterFluorescentMembrane3DSphere();
% segment the image
out=obj.segment(image3,'noshowplot');
% create cell contours based on the segmentation
%             [points,faces,edges,neighbors] = CellVision3D...
%                 .MeshBuilder3DSphere.generateMeshSphere(3);%
[points,faces,edges,neighbors] = obj.generateMeshSphere(3);
% initialize contours
contours=repmat(CellVision3D.Contour3D.empty,1,length(out));
% assign values for each contour
for i=1:length(out)
    contours(i)=CellVision3D.Contour3D(obj.label,obj.numframes,...
        points*sqrt(out(i).Area/pi).*...
        (ones(size(points,1),1)*[1 1 1/obj.zxr])+...
        ones(size(points,1),1)*out(i).Centroid,...
        faces,obj.zxr);
end
% save contours to it self
obj.contours=contours;
end