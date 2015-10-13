function [ img2 ] = imopen3( img,se )
%imopen3
img1= imerode3(img,se);
img2= imdilate3(img1,se);
end

