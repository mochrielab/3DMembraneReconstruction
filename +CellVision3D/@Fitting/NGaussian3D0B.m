function [ fmin ,grad] = NGaussian3D0B( p,x,y,z,img3,sigdiff,zxr)
%calculate image intensity for N guassian particles in 3D
% p, cx,cy,cz,sigmaxy,sigmaz,brightness
numk=size(p,1);
% totalnum=numel(img3);
I=zeros(size(x));
gradIij=repmat({zeros(size(img3))},size(p,1),size(p,2));
for i=1:numk
    eterm=exp(-((x-p(i,1)).^2+(y-p(i,2)).^2)/p(i,4)^2-(z-p(i,3)).^2/(p(i,4)+sigdiff)^2*zxr^2);
    I=I + p(i,5)*eterm;
    gradIij{i,1}=p(i,5)*eterm*(-2).*(p(i,1)-x)/p(i,4)^2;
    gradIij{i,2}=p(i,5)*eterm*(-2).*(p(i,2)-y)/p(i,4)^2;
    gradIij{i,3}=p(i,5)*eterm*(-2).*(p(i,3)-z)/(p(i,4)+sigdiff)^2*zxr^2;
    gradIij{i,4}=p(i,5)*eterm.*(2*((x-p(i,1)).^2+(y-p(i,2)).^2)/p(i,4)^3+2*(z-p(i,3)).^2/(p(i,4)+sigdiff)^3*zxr^2);
    gradIij{i,5}=eterm;
end

Idiff=I-img3;
grad=zeros(size(p));
for i=1:numk
    for j=1:5
        tmp=2*Idiff.*gradIij{i,j};
        grad(i,j)=sum(tmp(:));%/totalnum*1e3;
    end
end


fmin=Idiff.^2;
fmin=sum(fmin(:));%/totalnum*1e3;

end

