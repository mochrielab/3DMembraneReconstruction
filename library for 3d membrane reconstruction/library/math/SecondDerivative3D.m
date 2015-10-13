function [ Ixx,Iyy,Izz,Iyz,Izx,Ixy ] = SecondDerivative3D( img )
%calculate the second derivative of 3D images
[sy,sx,sz]=size(img);
img0=zeros(sy+2,sx+2,sz+2);
imgs=cell(3,3,3);
for iz=1:3
    for ix=1:3
        for iy=1:3
            imgs{iy,ix,iz}(iy+(1:sy),ix+(1:sx),iz+(1:sz))=img;
        end
    end
end

Ixx=imgs()

end

