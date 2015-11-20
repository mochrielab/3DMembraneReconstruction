function [ wimg ] = crop( img,roi )
%crop an image with
% roi=[miny,maxy,minx,max,minz,maxz]
% Yao Zhao 11/18/2015

dim=length(size(img));
sz=size(img);
if length(roi)~=2*dim
    warning('invalid roi vector');
else
    if dim==2
        wimg=img(max(1,roi(1)):min(sz(1),roi(2)),...
            max(1,roi(3)):min(sz(2),roi(4)));
    elseif dim==3
        wimg=img(max(1,roi(1)):min(sz(1),roi(2)),...
            max(1,roi(3)):min(sz(2),roi(4)),...
            max(1,roi(5)):min(sz(3),roi(6)));
    else
        warining('unsupported dimension');
    end
end

end

