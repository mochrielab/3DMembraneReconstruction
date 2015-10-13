function [ gconv ] = bpass3(img,lnoise,lobject,zxr )
%bpass for 3d

img2=zeros(size(img)+2*lobject);
img2(1+lobject:end-lobject,1+lobject:end-lobject,1+lobject:end-lobject)=img;
img=img2;
clear img2;

normalize = @(x) x/sum(x(:));

if lnoise == 0
  gaussian_kernel1 = 1;
  gaussian_kernel2 = 1;
else      
%   [X,Y,Z]=meshgrid(-ceil(5*lnoise):ceil(5*lnoise),-ceil(5*lnoise):ceil(5*lnoise),...
%       -ceil(5*lnoise/zxr):ceil(5*lnoise/zxr));
  gaussian_kernel1 = normalize(exp(-((-ceil(5*lnoise):ceil(5*lnoise))/(2*lnoise)).^2))';  
  gaussian_kernel2 = normalize(exp(-((-ceil(5*lnoise/zxr):ceil(5*lnoise/zxr))/(2*lnoise)).^2))';
end

if lobject
% boxcar_kernel= normalize(ones(length(-ceil(lobject):ceil(lobject)),...
%     length(-ceil(lobject):ceil(lobject)),length(-ceil(lobject/zxr):ceil(lobject/zxr))));
    boxcar_kernel1=normalize(ones(length(-ceil(lobject):ceil(lobject)),1));
    boxcar_kernel2=normalize(ones(length(-ceil(lobject/zxr):ceil(lobject/zxr)),1));
end

gconv=convn(img,gaussian_kernel1,'same');
gconv=convn(permute(gconv,[2 1 3]),gaussian_kernel1,'same');
gconv=convn(permute(gconv,[3 1 2]),gaussian_kernel2,'same');
gconv=permute(gconv,[3 2 1]);

if lobject
bconv=convn(img,boxcar_kernel1,'same');
% bconv=convn(gconv,boxcar_kernel1,'same');
bconv=convn(permute(bconv,[2 1 3]),boxcar_kernel1,'same');
bconv=convn(permute(bconv,[3 1 2]),boxcar_kernel2,'same');
bconv=permute(bconv,[3 2 1]);

gconv=gconv-bconv;
end


gconv(gconv<0)=0;
gconv=gconv(1+lobject:end-lobject,1+lobject:end-lobject,1+lobject:end-lobject);

end

