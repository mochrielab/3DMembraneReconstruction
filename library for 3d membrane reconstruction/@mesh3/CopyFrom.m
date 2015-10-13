function [ obj ] = CopyFrom( obj, obj2 )
%copy the patch data from another object

obj.vertices=obj2.vertices;
obj.faces=obj2.faces;
obj.edges=obj2.edges;
obj.neighbors=obj2.neighbors;
obj.isoutward=obj2.isoutward;
obj.vertexnormals=obj2.vertexnormals;

end

