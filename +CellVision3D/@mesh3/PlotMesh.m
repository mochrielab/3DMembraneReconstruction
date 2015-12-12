function [ obj ] = PlotMesh( obj )
%plot the mesh of obj
% 3/12/2015 Yao Zhao

%% 
clf
% plot the comparison
% img1=zeros(size(obj.img3)+2);
% img1(2:end-1,2:end-1,2:end-1)=obj.img3;
img1=obj.image;
p2=isosurface(img1,.5*img1);
p2.vertices(:,3)=p2.vertices(:,3)*obj.zxr;

p1.vertices=obj.vertices;
p1.faces=obj.faces;
% p1.vertices=ptsnew;

SP(p1,[],'k',.5);
SP(p2,'b',[],.5);

legend('fitted','original');

if ~isempty(obj.vertexnormals)

pts=obj.vertices;
faces=obj.faces;
% pc=(pts(faces(:,1),:)+pts(faces(:,2),:)+pts(faces(:,3),:))/3;
vn=obj.vertexnormals;
% fn=obj.facenormals;
pp=pts;
nn=vn;
if obj.isoutward==0
    nn=-nn;
end
hold on;
quiver3(pp(:,1),pp(:,2),pp(:,3),nn(:,1),nn(:,2),nn(:,3),'color','y');
end

extsiz=5;
axis([1+extsiz size(obj.image,2)-extsiz 1+extsiz size(obj.image,1)-extsiz...
    1+extsiz (size(obj.image,3)-extsiz)*obj.zxr]);
axis equal;

end

