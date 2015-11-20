function [ I ] = NGaussian3D( p,x,y,z )
%calculate image intensity for N guassian particles in 3D
% p, cx,cy,cz,sigmaxy,sigmaz,brightness
num=size(p,1);
I=zeros(size(x));
for i=1:num
    I=I + p(i,6)*...
        exp(-((x-p(i,1)).^2+(y-p(i,2)).^2)/p(i,4)^2-(z-p(i,3)).^2/p(i,5)^2);
end

end



