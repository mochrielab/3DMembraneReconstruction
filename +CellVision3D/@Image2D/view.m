function [  ] = view( varargin )
% 2d image view

tn=nargin;
m=ceil(sqrt(tn));
n=ceil(tn/m);
if tn==1
    imagesc(varargin{1});axis image;colormap gray;
else
for i=1:m*n
    subplot(n,m,i)
    imagesc(varargin{i});axis image;colormap gray;
end
end

end

