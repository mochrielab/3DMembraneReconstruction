function [ ds ] = CompareShape ( obj, obj2 )
%compare the error between two shapes

pts=obj.vertices;

ds=zeros(size(pts,1),1);

for ipts=1:size(pts,1)
    [d,ss]=distance2shape(obj2,pts(ipts,:));
    ds(ipts)=d*ss;
end

end

