function [ img2 ] = imclose3( img,se )
%imclose3
img1= imdilate3(img,se);
img2= imerode3(img1,se);
end

