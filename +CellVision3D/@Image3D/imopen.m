function [ img2 ] = imopen( img,se )
%imopen3
img1= CellVision3D.Image3D.imerode(img,se);
img2= CellVision3D.Image3D.imdilate(img1,se);
end

