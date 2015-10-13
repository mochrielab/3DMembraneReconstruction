function [ output_args ] = ShowPos( pos )
%show 3d position
numframe=max(pos(:,4));
X=pos(:,1);
Y=pos(:,2);
Z=pos(:,3);
T=pos(:,4);
for i=1:20:numframe
    x=X(T==i);
    y=Y(T==i);
    z=Z(T==i);
    plot3(x,y,z,'.');
    axis equal;
    pause;
end
end

