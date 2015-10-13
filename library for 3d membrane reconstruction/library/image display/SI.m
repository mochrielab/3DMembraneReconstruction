function [] = SI( varargin)
%quick show image
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
% f=figure;
% if nargin==1
%     imagesc(varargin{1});axis image;colormap gray;
% elseif nargin==2
%     subplot(1,2,1)
%     imagesc(varargin{1});axis image;colormap gray;
%     subplot(1,2,2)
%     imagesc(varargin{2});axis image;colormap gray;
% elseif nargin==3
%         subplot(1,3,1)
%     imagesc(varargin{1});axis image;colormap gray;
%     subplot(1,3,2)
%     imagesc(varargin{2});axis image;colormap gray;    
%     subplot(1,3,3)
%     imagesc(varargin{3});axis image;colormap gray;
% elseif nargin==4
%     subplot(2,2,1)
%     imagesc(varargin{1});axis image;colormap gray;
%     subplot(2,2,2)
%     imagesc(varargin{2});axis image;colormap gray;
%     subplot(2,2,3)
%     imagesc(varargin{3});axis image;colormap gray;
%     subplot(2,2,4)
%     imagesc(varargin{4});axis image;colormap gray;
% else 
%     warning('unsupported number of inputs');
% end

end

