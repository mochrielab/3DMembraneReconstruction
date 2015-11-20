function drift=getDrift(obj, channel)
% get drift from a template for the whole channel
% 11/19/2015 yao Zhao

% intialize
numframes=channel.numframes;
drift=zeros(numframes,3);

% set first reference point
[refcnt]=getCenters(obj, channel.grabImage3D(1));

for iframe=1:numframes
    % set new center
    [newcenter]=getCenters(obj, channel.grabImage3D(iframe));
    if sum(isnan(newcenter))==0
        % calculate drift
        drift(iframe,:)=newcenter-refcnt;
        % update centers
        obj.centroid=round(newcenter(1:2));
    else
    end
end

obj.positiondrift=drift;


end

