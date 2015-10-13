function [ inten ] = InterpImage( img,pts )
%interpolate 3D/2D image the intensity value of image file

dim=length(size(img));
fpts=floor(pts);
dpts=pts-fpts;
inten=zeros(size(pts,1),1);
if dim==2
    for id=0:3
        ix=mod(id,2);
        iy=floor(id/2);
        dx= dpts(:,1)*ix + (1-dpts(:,1))*(1-ix);
        dy= dpts(:,2)*iy + (1-dpts(:,2))*(1-iy);
        inten = inten + img(sub2ind(size(img),fpts(:,2)+iy,fpts(:,1)+ix)).*dx.*dy;
    end
elseif dim==3
    for id=0:7
        ix=mod(id,2);
        iy=mod(floor(id/2),2);
        iz=floor(id/4);
        dx= dpts(:,1)*ix + (1-dpts(:,1))*(1-ix);
        dy= dpts(:,2)*iy + (1-dpts(:,2))*(1-iy);
        dz= dpts(:,3)*iz + (1-dpts(:,3))*(1-iz);
        inten = inten + ...
            img(sub2ind(size(img),fpts(:,2)+iy,fpts(:,1)+ix,fpts(:,3)+iz))...
            .*dx.*dy.*dz;
    end
end


end

% fpx=floor(px);
% fpy=floor(py);
% fpz=floor(pz);
% dpx=px-fpx;
% dpy=py-fpy;
% dpz=pz-fpz;

% ind000=sub2ind(img3,fpx,p
% ind001=
% ind010=
% ind011=
% ind100=
% ind101=
% ind110=
% ind111=

% indall=zeros(length(px),
