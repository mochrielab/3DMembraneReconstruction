
function cnt=getCentroid(obj,varargin)
% get centroid of the object
% may pass in 1 variable to get centroid from that frame
% Yao Zhao 12/11/2015

currentframe=obj.iframe;
if nargin>=2
    currentframe=varargin{1};
end

cnt=zeros(length(obj),3);
for ip=1:length(obj)
    if currentframe==0
        cnt(ip,:)=mean(obj(ip).tmpvertices,1);
    else
        cnt(ip,:)=mean(obj(ip).vertices{currentframe},1);
    end
end
end