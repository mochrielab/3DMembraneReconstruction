function [ r ] = distance3D_zxr( p1, p2, zxr )
%calculate the pixel distance between two 3D points, corrected for zxr
%ratio

r=sqrt((p1(:,1)-p2(:,1)).^2+(p1(:,2)-p2(:,2)).^2+(p1(:,3)-p2(:,3)).^2*zxr^2);

end

