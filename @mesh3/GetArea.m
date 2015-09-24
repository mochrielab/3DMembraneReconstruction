function [ areas ] = GetArea( obj )
%get the Areas of patches

pts=obj.vertices;

% initialize
areas=zeros(obj.numpatches,1);
for ipatch=1:obj.numpatches
    faces=obj.faces(obj.facespid==ipatch,:);
    numpts=size(pts,1);
    numfaces=size(faces,1);
    for iface=1:numfaces
        p1=pts(faces(iface,1),:);
        p2=pts(faces(iface,2),:);
        p3=pts(faces(iface,3),:);
        areas(ipatch)=areas(ipatch)+1/2*norm(cross(p2-p1,p3-p2));
    end
end

end

