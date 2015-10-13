function [ wimg ] = winimg3( cnt,img,wz,zxr )
%cut window image from 3d image with window size wz
if length(wz)==1
    if mod(wz,2)==0
        warning('window size need to be odd');
    end
    hwz=(wz-1)/2;
    cx=round(cnt(1));
    cy=round(cnt(2));
    cz=round(cnt(3));
    xr=max(cx-hwz,1):min(cx+hwz,size(img,2));
    yr=max(cy-hwz,1):min(cy+hwz,size(img,1));
    zr=max(cz-ceil(hwz/zxr),1):min(cz+ceil(hwz/zxr),size(img,3));
    wimg=img(yr,xr,zr);
elseif length(wz)==3
    hwz=(wz-1)/2;
    cx=round(cnt(1));
    cy=round(cnt(2));
    cz=round(cnt(3));
    xr=max(cx-hwz(1),1):min(cx+hwz(1),size(img,2));
    yr=max(cy-hwz(2),1):min(cy+hwz(2),size(img,1));
    zr=max(cz-hwz(3),1):min(cz+hwz(3),size(img,3));
    wimg=img(yr,xr,zr);
else
    warning('wrong window size');
end
end

