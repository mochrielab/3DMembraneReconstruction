function [ img2 ] = imerode3f( img,l )
%fast 3d cubic erode with full window l
[wy,wx,wz]=size(img);
hl=(l-1)/2;
img2=zeros(wy+l-1,wx+l-1,wz+l-1)+inf;
img2(hl+1:hl+wy,hl+1:hl+wx,hl+1:hl+wz)=img;
for i=hl+1:size(img2,1)-hl
    img2(i,:,:)=min(img2(i-hl:i+hl,:,:));
end
img2=permute(img2,[2 1 3]);
for i=hl+1:size(img2,1)-hl
    img2(i,:,:)=min(img2(i-hl:i+hl,:,:));
end
img2=permute(img2,[3 1 2]);
for i=hl+1:size(img2,1)-hl
    img2(i,:,:)=min(img2(i-hl:i+hl,:,:));
end
img2=permute(img2,[3 2 1]);
img2=img2(hl+1:hl+wy,hl+1:hl+wx,hl+1:hl+wz);
end


