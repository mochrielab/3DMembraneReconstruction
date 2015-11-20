function [ fmin ,grad] = NGaussian2D0B( p,x,y,img)
%calculate image intensity for N guassian particles in 2D
% p= cx,cy,sigmaxy,brightness
numk=size(p,1);
I=zeros(size(x));
gradIij=repmat({zeros(size(img))},size(p,1),size(p,2));
for i=1:numk
    eterm=exp(-((x-p(i,1)).^2+(y-p(i,2)).^2)/p(i,3)^2);
    I=I + p(i,4)*eterm;
    gradIij{i,1}=p(i,4)*eterm*(-2).*(p(i,1)-x)/p(i,3)^2;
    gradIij{i,2}=p(i,4)*eterm*(-2).*(p(i,2)-y)/p(i,3)^2;
    gradIij{i,3}=p(i,4)*eterm.*(2*((x-p(i,1)).^2+(y-p(i,2)).^2)/p(i,3)^3);
    gradIij{i,4}=eterm;
end

Idiff=I-img;
grad=zeros(size(p));
for i=1:numk
    for j=1:4
        tmp=2*Idiff.*gradIij{i,j};
        grad(i,j)=sum(tmp(:));%/totalnum*1e3;
    end
end


fmin=Idiff.^2;
fmin=sum(fmin(:));%/totalnum*1e3;

end

