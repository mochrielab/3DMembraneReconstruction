function [ gconv ] = gausspass3(img,sxy,sz )
%gaussian filter for for 3d

normalize = @(x) x/sum(x(:));

if sxy == 0
  gaussian_kernel1 = 1;
else      
  gaussian_kernel1 = normalize(exp(-((-ceil(5*sxy):ceil(5*sxy))/(sxy)).^2))';  
end

if sz == 0
  gaussian_kernel2 = 1;
else      
  gaussian_kernel2 = normalize(exp(-((-ceil(5*sz):ceil(5*sz))/(sz)).^2))';  
end


gconv=convn(img,gaussian_kernel1,'same');
gconv=convn(permute(gconv,[2 1 3]),gaussian_kernel1,'same');
gconv=convn(permute(gconv,[3 1 2]),gaussian_kernel2,'same');
gconv=permute(gconv,[3 2 1]);

end

