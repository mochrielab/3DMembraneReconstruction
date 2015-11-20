function [ im,bg,p ] = removeLinearBackground( im )
%fit the image background to a 2 component linear function and remvoe the
%background
% input: 2D image
% output: processed 2D image
%         background image
%         fitted parameter
% Yao Zhao 11/16/2015

%%
% im=im0;
[height,width]=size(im);
x=1:width;
y=1:height;      
[x,y]=meshgrid(x,y);
mask=ones(size(im))==1;
% se=strel('disk',1);
for i=1:5
mx=mean(x(mask));
my=mean(y(mask));
mz=mean(im(mask));
mx2=mean(x(mask).^2);
my2=mean(y(mask).^2);
mxy=mean(x(mask).*y(mask));
mzx=mean(x(mask).*im(mask));
myz=mean(y(mask).*im(mask));
p=[1,mx,my;mx,mx2,mxy;my,mxy,my2]^-1*[mz;mzx;myz];
sigma=(p(1)+p(2)*x+p(3)*y-im).^2;
mask=sigma<1.5*mean(sigma(:));
% mask=bwmorph(mask,'close');
% mask=imclose(mask,se);
% imagesc(mask);pause;
% p
end

bg=p(1)+x*p(2)+y*p(3);
im=im-bg;

% SI(mask);

end

