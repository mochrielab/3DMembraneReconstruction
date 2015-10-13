function [ swimg ] = WindowImage(mx,my,wsize,img )
%Take a scaled windowed image from a picture;
%   Input: mx, my wsize, img
mx=round(mx);
my=round(my);
wx=mx-wsize:mx+wsize;
wy=my-wsize:my+wsize;
wimg=img(wy,wx);
minw=min(wimg(:));
maxw=max(wimg(:));
swimg=(wimg-minw)/(maxw-minw);
end

