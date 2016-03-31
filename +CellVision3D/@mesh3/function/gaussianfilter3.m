function [ gconv ] = gaussianfilter3( img,lnoise)
%apply a 3d gaussian filter
% 3/18/2015


normalize = @(x) x/sum(x(:));

if lnoise == 0
  gaussian_kernel1 = 1;
%   gaussian_kernel2 = 1;
else      
%   [X,Y,Z]=meshgrid(-ceil(5*lnoise):ceil(5*lnoise),-ceil(5*lnoise):ceil(5*lnoise),...
%       -ceil(5*lnoise/zxr):ceil(5*lnoise/zxr));
  gaussian_kernel1 = normalize(exp(-((-ceil(5*lnoise):ceil(5*lnoise))/(2*lnoise)).^2))';  
%   gaussian_kernel2 = normalize(exp(-((-ceil(5*lnoise/zxr):ceil(5*lnoise/zxr))/(2*lnoise)).^2))';
end
gaussian_kernel2=gaussian_kernel1;

gconv=convn(img,gaussian_kernel1,'same');
gconv=convn(permute(gconv,[2 1 3]),gaussian_kernel1,'same');
gconv=convn(permute(gconv,[3 1 2]),gaussian_kernel2,'same'); %
gconv=permute(gconv,[3 2 1]);

end

