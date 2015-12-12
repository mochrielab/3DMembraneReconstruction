
function cnt=getCentroid(obj,varargin)
% get centroid of the object
% may pass in 1 variable to get centroid from that frame
% Yao Zhao 12/11/2015
dim=obj(1).dimension;
currentframe=obj.iframe;
if nargin>=2
    currentframe=varargin{1};
end

cnt=zeros(length(obj),obj(1).dimension);
for ip=1:length(obj)
    if currentframe==0
        cnt(ip,:)=obj(ip).tmppos(1:dim);
    else
        cnt(ip,:)=obj(ip).positions(currentframe,1:dim);
    end
end
end