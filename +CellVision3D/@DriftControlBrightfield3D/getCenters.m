function [newcenter]=getCenters(obj, img3)
% set new image as center 
% 11/19/2015 Yao zhao


% get croped
cnt=obj.centroid;
hs=(obj.windowsize-1)/2;
chs=(obj.correlationwindowsize-1)/2;
wimg3=CellVision3D.Image3D...
    .crop(img3,[cnt(2)-hs,cnt(2)+hs,cnt(1)-hs,cnt(1)+hs,1,size(img3,3)]);
% get parameter
[params] = obj.getCorrelations(wimg3,obj.template);
% find drift
numstacks=size(img3,3);
% save result
c=params(:,4);
lockxcenter=nan;
lockycenter=nan;
lockzcenter=nan;
for i=1:numstacks-1
    if c(i)<=obj.lockthreshold && c(i+1)>obj.lockthreshold
        % slope of fitting by nearby two points
        locksensitivity=c(i+1)-c(i);
        lockzcenter=i+...
            (obj.lockthreshold-c(i))/locksensitivity;
        w=lockzcenter-i;
        % interpolated xy center
        lockxcenter = params(i,1)*(1-w)+params(i+1,1)*w+cnt(1)-chs-1;
        lockycenter = params(i,2)*(1-w)+params(i+1,2)*w+cnt(2)-chs-1;
        break;
    end
end
    plot((1:numstacks)*0.2,params(:,4),'o-');hold on;pause(.1);

% obj.lockxcenter=lockxcenter;
% obj.lockycenter=lockycenter;
% obj.lockzcenter=lockzcenter;

newcenter=[lockxcenter,lockycenter,lockzcenter];

end

