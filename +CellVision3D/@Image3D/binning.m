function [ b ] = binning( img3, bin )
% bin the image 3 dimensionly
% start with [1 1 1] will drop leftovers near end
% bin must be integer number
% bin can be xyz, or [xy, z]
% 3/20/2015 Yao Zhao

if length(bin)==1
    bin=[bin,bin];
end
bin = [bin(1),bin(1),bin(2)];

bsz=floor(size(img3)./bin);
b=zeros(bsz);

% if scale is 1
if cumprod(bin==1)==1
    b=img3;
    return
end


for iz=1:bsz(3)
    for ic=1:bsz(2)
        for ir=1:bsz(1)
            tmp = img3((ir-1)*bin(1)+(1:bin(1)),...
                (ic-1)*bin(2)+(1:bin(2)),...
                (iz-1)*bin(3)+(1:bin(3)));
            b(ir,ic,iz)=sum(tmp(:));
        end
    end
end


end

