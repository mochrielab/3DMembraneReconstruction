function [  ] = SI3( img,varargin)
%show plot of 3 d image
if nargin==1
    dim=3;
else
    dim=varargin{1};
end

if dim==3
    for i=1:size(img,3)
        imagesc(img(:,:,i),[min(img(:)),max(img(:))]);
        colormap gray;
        axis image;
        pause;
    end
elseif dim==2
    for i=1:size(img,2)
        imagesc(squeeze(img(:,i,:)),[min(img(:)),max(img(:))]);
        colormap gray;
        axis image;
        pause;
    end
    
end


end

