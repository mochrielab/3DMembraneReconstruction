function [ areas ] = getArea( obj )
% get area of the contour surface for each frame
% Yao Zhao 9/17/2016

numframes = obj.numframes;
areas=zeros(numframes,1);
for iframe=1:length(numframes)
    vertices = obj.vertices{iframe};
    faces = obj.faces{iframe};
    for iface=1:size(faces,1)
        p1=vertices(faces(iface,1),:);
        p2=vertices(faces(iface,2),:);
        p3=vertices(faces(iface,3),:);
        areas(iframe)=areas(iframe)+1/2*abs(cross(p2-p1,p3-p2));
    end
end

end

