function [ fmin, grad, fval ] = Lorentzian1D( p, xarray, yarray )
% lorenzian function 1D fitting
% fval = p(3)/(1+(xarray-p(1)).^2/p(2)^2)+p(4)
%   P(1) peak position
%   P(2) peak width sigma
%   P(3) peak height
%   P(4) background
% 
%  Yao Zhao 3/23/2015

fval =  zeros(size(xarray));
grad = zeros(size(p));

% assign parameter
mx=p(1);
sigma=p(2);
height=p(3);
bg=p(4);

% calculate tmp variables
x = (xarray-mx)/sigma;
x2 = x.^2;
inv = 1./(1+x2);
inv2 = inv.^2;

% calculate fval
fval = height*inv + bg;

% calclate diff
fdiff = fval-yarray;

% calculate fmin
fmin = sum((fdiff.^2));

% calculate grad
dfdmx=2*fdiff.*inv2.*x/sigma*height;
dfdsigma=grad(1).*x;
dfdheight=2*fdiff.*inv;
dfdbg=2*fdiff;

grad(1)=sum(dfdmx);
grad(2)=sum(dfdsigma);
grad(3)=sum(dfdheight);
grad(4)=sum(dfdbg);

% 
% fval=zeros(size(xarray));
% gradIij=repmat({zeros(size(yarray))},size(p,1),size(p,2));
% for i=1:numk
%     eterm=exp(-((xarray-p(i,1)).^2)/p(i,2)^2);
%     fval=fval + p(i,3)*eterm;
%     gradIij{i,1}=p(i,3)*eterm*(-2).*(p(i,1)-xarray)/p(i,2)^2;
%     gradIij{i,2}=p(i,3)*eterm.*(2*((xarray-p(i,1)).^2)/p(i,2)^3);
%     gradIij{i,3}=eterm;
% end
% 
% Idiff=fval-yarray;
% grad=zeros(size(p));
% for i=1:numk
%     for j=1:3
%         tmp=2*Idiff.*gradIij{i,j};
%         grad(i,j)=sum(tmp(:));%/totalnum*1e3;
%     end
% end
% 
% 
% fmin=Idiff.^2;
% fmin=sum(fmin(:));%/totalnum*1e3;


end
