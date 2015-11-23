function [ fmin, grad, fval ] = NGaussian1D0B( p, xarray, yarray )
% calculate image intensity for N guassian particles in 1D with no background
% inputs: p, parameters, xarray, input array, yarray, observation array
%   P(3) peak height
%   P(1) peak position
%   P(2) peak width sigma


numk=size(p,1);
fval=zeros(size(xarray));
gradIij=repmat({zeros(size(yarray))},size(p,1),size(p,2));
for i=1:numk
    eterm=exp(-((xarray-p(i,1)).^2)/p(i,2)^2);
    fval=fval + p(i,3)*eterm;
    gradIij{i,1}=p(i,3)*eterm*(-2).*(p(i,1)-xarray)/p(i,2)^2;
    gradIij{i,2}=p(i,3)*eterm.*(2*((xarray-p(i,1)).^2)/p(i,2)^3);
    gradIij{i,3}=eterm;
end

Idiff=fval-yarray;
grad=zeros(size(p));
for i=1:numk
    for j=1:3
        tmp=2*Idiff.*gradIij{i,j};
        grad(i,j)=sum(tmp(:));%/totalnum*1e3;
    end
end


fmin=Idiff.^2;
fmin=sum(fmin(:));%/totalnum*1e3;


end
