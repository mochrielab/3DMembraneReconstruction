function [ obj ] = calculateVertexNormalDirection( obj )
% calculate the interpolated face normal value at each vertex point
% calculate face area, face normal, vertex normal, isoutward
% 3/12/2015 Yao Zhao

pts=obj.vertices;
faces=obj.faces;
edges=obj.edges;
neighbors=obj.neighbors;
numpts=size(pts,1);
numfaces=size(faces,1);
numedges=size(edges,1);

%face normal area: area with face normal direction
p21=pts(faces(:,2),:)-pts(faces(:,1),:);
p32=pts(faces(:,3),:)-pts(faces(:,2),:);
dirarea=1/2*cross(p21,p32,2);
facearea= sqrt(sum(dirarea.^2,2));
facenormals= dirarea./(facearea*ones(1,3));
% calcualte the vertex normal
vertexnormals=zeros(numpts,3);
for ifaces=1:numfaces
    for j=1:3
    vertexnormals(faces(ifaces,j),:)=...
        vertexnormals(faces(ifaces,j),:)+facenormals(ifaces,:);
    end
end
vertexnormals=vertexnormals./(sqrt(sum(vertexnormals.^2,2))*ones(1,3));

% decide outwardness
isoutward=zeros(obj.numpatches,1);
for ipatch=1:obj.numpatches
[~,indxpts]=min(pts(obj.ptspid==ipatch,1));
vertextmp=vertexnormals(obj.ptspid==ipatch);
isoutward(ipatch)=(vertextmp(indxpts,1)<0);
end
%%
% obj.facearea=facearea;
% obj.facenormals=facenormals;
obj.vertexnormals=vertexnormals;
obj.isoutward=isoutward;
end

