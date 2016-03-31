function [ img2 ] = imclose( img,se )
%imclose3
img1= CellVision3D.Image3D.imdilate(img,se);
img2= CellVision3D.Image3D.imerode(img1,se);
end

