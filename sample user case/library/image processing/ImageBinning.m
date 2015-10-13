function [ newimg ] = ImageBinning( img, binsize )
%bin image by size
% 3/12/2015 Yao Zhao

%%
imgsize=size(img);
dim=length(imgsize);

if length(binsize)==1;
    binsize=zeros(size(imgsize))+binsize;
end

if length(binsize)~=dim
    error('dimension must equal to binsize length');
end

newsiz=floor(imgsize./binsize);
newimg=zeros(newsiz);
if dim==2
    for j=1:newsiz(2)
        for i=1:newsiz(1)
            subimg=img((i-1)*binsize(1)+(1:binsize(1)),(j-1)*binsize(2)+(1:binsize(2)));
            newimg(i,j)=mean(subimg(:));
        end
    end
end
if dim==3
    for k=1:newsiz(3)
        for j=1:newsiz(2)
            for i=1:newsiz(1)
                subimg=img((i-1)*binsize(1)+(1:binsize(1)),(j-1)*binsize(2)+(1:binsize(2)),...
                    (k-1)*binsize(3)+(1:binsize(3)));
                newimg(i,j,k)=mean(subimg(:));
            end
        end
    end
end


end

