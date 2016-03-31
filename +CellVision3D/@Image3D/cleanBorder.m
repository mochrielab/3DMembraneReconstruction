function [ img3 ] = cleanBorder( img3, bordercut )
% set the pixel values near the border to be zero

if length(bordercut)==1
    xbordercut=bordercut;
    zbordercut=bordercut;
elseif length(bordercut)==2
    xbordercut=bordercut(1);
    zbordercut=bordercut(2);
end


[x,y,z]=meshgrid(1:size(img3,2),1:size(img3,1),1:size(img3,3));
img3(...
      x<=xbordercut...
    | y<=xbordercut...
    | z<=zbordercut...
    | x>size(img3,2)-xbordercut...
    | y>size(img3,1)-xbordercut...
    | z>=size(img3,3)-zbordercut...
    ) =0 ;

    
end

