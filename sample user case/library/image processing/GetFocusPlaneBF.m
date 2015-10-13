function [ focusplane ] = GetFocusPlaneBF( img3 )
%get focus plane of a bright field image 3d stack

%% auto focus
numstacks=size(img3,3);
contrast=zeros(numstacks,1);
for istack=1:numstacks
    imgmag=imgradient(squeeze(img3(:,:,istack)));
    contrast(istack)=mean(imgmag(:));
end
% plot(contrast);

[~,focusplane]=min(contrast);
end

