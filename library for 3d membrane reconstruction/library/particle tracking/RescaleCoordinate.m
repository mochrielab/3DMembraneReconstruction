function [ rpos ] = RescaleCoordinate( pos, center, orientation )
%rescale coordinate at the center
rpos=pos;
pos1=pos(:,1:3)-ones(size(pos,1),1)*center;
x=pos1(:,1);
y=pos1(:,2);
theta=orientation/180*pi;
rpos(:,1)=x*cos(theta) - y*sin(theta);
rpos(:,2)=y*cos(theta) + x*sin(theta);
rpos(:,3)=pos1(:,3);

end

