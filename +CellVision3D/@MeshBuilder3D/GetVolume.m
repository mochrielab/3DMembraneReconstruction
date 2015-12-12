function [ vols ] = GetVolume( obj )
%get volumes of each patches

pts=obj.vertices;

% initialize
vols=zeros(obj.numpatches,1);
for ipatch=1:obj.numpatches
    faces=obj.faces(obj.facespid==ipatch,:);
    numfaces=size(faces,1);
    for iface=1:numfaces
        p1=pts(faces(iface,1),:);
        p2=pts(faces(iface,2),:);
        p3=pts(faces(iface,3),:);
        vols(ipatch)=vols(ipatch)+1/6*(cross(p2-p1,p3-p2)*p2');
    end
    if obj.isoutward(ipatch)==0
        vols(ipatch)=vols(ipatch)*-1;
    end
end
end

