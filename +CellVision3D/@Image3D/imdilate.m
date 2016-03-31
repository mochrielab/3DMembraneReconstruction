function [ img ] = imdilate( img, se, varargin )
%3d dilate image
% image, mask, output option
%se is a 3d kernal image
%use non zero area to define the shape, se consist of only 0 and 1
% mask values are not enabled yet, will be adjusted in the future
% 3/18/2015

if isa(se,'strel')
    se=se.getnhood;
end

finalsize='same';
if nargin>2
    if~isempty(varargin{1})
        finalsize=varargin{1};
    end
end


[wy,wx,wz]=size(img);
[wy1,wx1,wz1]=size(se);
hwy=(wy1-1)/2;
hwx=(wx1-1)/2;
hwz=(wz1-1)/2;

img2=zeros(wy+wy1-1,wx+wx1-1,wz+wz1-1)-inf;
img2(hwy+1:hwy+wy,hwx+1:hwx+wx,hwz+1:hwz+wz)=img;
img=img2;

for i=hwy+1:hwy+wy
    for j=hwx+1:hwx+wx
        for k=hwz+1:hwz+wz
            wimg=img2(i-hwy:i+hwy,j-hwx:j+hwx,k-hwz:k+hwz);
            wimg(se<=0)=-inf;
            img(i,j,k)= max(wimg(:));
        end
    end
end

if strcmp(finalsize,'full')
elseif strcmp(finalsize,'same')
    img=img(1+hwy:end-hwy,1+hwx:end-hwx,1+hwz:end-hwz);
else
    error('wrong option for output');
end

end

