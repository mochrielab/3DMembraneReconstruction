function [ p ] = genRodMesh( l,ncap )
%generate a rod mesh 
% the radius of the cap is 1
% input: l, length of the body part (unit of 1/n)
%        n, number of vertices at each circle
% example: 
%           p=genRodMesh(6,4);
%           patch(p,'FaceColor','r');
%           camlight;
%           view(3);
%           lighting gouraud
%           daspect([1 1 1]);

% 10/7/2015
% Yao Zhao

%%
% ncap =5 ;
% l= 7 ;
% ncap=round(n/4);
n=ncap*4;
vertices=zeros((ncap*2+l)*n,3);
faces=zeros((ncap*2+l-1)*n,4);

for i=1:size(vertices,1)
    iring = floor((i-1)/n);
    itheta = mod((i-1),n)/n*2*pi;
    if iring<= ncap-1
        phi=iring/ncap*pi/2;
        r = sin(phi);
        z = -l/2/ncap - cos(phi);
    elseif iring >= ncap+l-1
        phi=(ncap*2+l-1-iring)/ncap*pi/2;
        r = sin(phi);
        z = l/2/ncap + cos(phi);
    else
        r = 1;
        z = (iring - (ncap + l/2))/ncap;
    end
    vertices(i,:)= [r*cos(itheta),r*sin(itheta),z];
end

for i=1:size(faces,1)
    i1 = floor((i-1)/n);
    i2 = mod(i,n);
    if i2 ==0
        faces(i,:) = [i1*n+1,i1*n+n,i1*n+2*n,i1*n+n+1];
    else
        faces(i,:) = [i1*n+i2+1,i1*n+i2,i1*n+n+i2,i1*n+n+i2+1];
    end
end

faces(faces<=n)=1;
faces(faces>=size(vertices,1)-n+1)=size(vertices,1)-n+1;

p.Vertices=vertices;
p.Faces=faces;


end

