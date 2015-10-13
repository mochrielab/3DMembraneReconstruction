function [ wimg ] = WindowImageUS(mx,my,wsize,img )
%Take a scaled windowed image from a picture; UnScaled
%   Input: mx, my wsize, img
mx=round(mx);
my=round(my);
img_wide=zeros(size(img,1)+2*wsize,size(img,2)+2*wsize);
img_wide(wsize+1:end-wsize,wsize+1:end-wsize)=img;
wx=(mx-wsize:mx+wsize)+wsize;
wy=(my-wsize:my+wsize)+wsize;
wimg=img_wide(wy,wx);

end

