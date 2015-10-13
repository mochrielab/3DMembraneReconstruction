function [ obj ] = BalaceTriangleArea( obj )
%balance the size of the triangles by moving the edges of triangles
% 3/14/2015 Yao Zhao

% there is a bug with this function!!!!!
% try to find it...

if obj.diagnostic_mod_on==1
    obj.DiagnoseMeshTopology;
end

pts=obj.vertices;
faces=obj.faces;
edges=obj.edges;
neighbors=obj.neighbors;
numpts=size(pts,1);
numfaces=size(faces,1);
numedges=size(edges,1);
% edges

%loop through all the edges
for iedge=1:numedges
    edgetmp=edges(iedge,:);
    p1=pts(edgetmp(1),:);
    p2=pts(edgetmp(2),:);
    p3=pts(edgetmp(5),:);
    p4=pts(edgetmp(6),:);
    pc=(p3+p4)/2;
    p21=p2-p1;
    pts(edgetmp(1),:)=pc-p21/2;
    pts(edgetmp(2),:)=pc+p21/2;
%     area=1/2*(p4-p3)*(p2-p1)';
end

% end
obj.vertices=pts;
obj.faces=faces;
obj.edges=edges;
obj.neighbors=neighbors;

end

