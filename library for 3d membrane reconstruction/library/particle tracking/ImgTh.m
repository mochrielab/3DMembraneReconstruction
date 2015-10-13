function [ th ] = ImgTh( img, percent )
% Find the threshould above which the double image has percent pixes above
% Input:
%       img
%       percentage
dimg=double(img(:));
[counts,bins]=hist(dimg/max(dimg(:)),0:0.01:1);
cumcounts=cumsum(counts);
countfilter=cumcounts>(percent*sum(counts));
th_index=[countfilter(2:end)-countfilter(1:end-1),0];
th=bins(th_index==1)*max(dimg(:));
if isempty(th)
    th=0;
    warning('all image save value');
end

end

