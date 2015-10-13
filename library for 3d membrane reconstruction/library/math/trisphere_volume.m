function [ volume ] = trisphere_volume( points,faces )
%calculate the volume of trisphere
volume=0;
for i=1:size(faces)
    edge1=points(faces(i,1),:)-points(faces(i,2),:);
    edge2=points(faces(i,3),:)-points(faces(i,2),:);
    edge3=points(faces(i,2),:);
    volume=volume+abs(cross(edge1,edge2)*edge3')/6;
end
end

