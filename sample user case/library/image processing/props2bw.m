function [ bw ] = props2bw( props, im )
%create a bw image based on props list
bw=zeros(size(im));
for i=1:length(props)
    bw(props(i).PixelIdxList)=1;
end

end

