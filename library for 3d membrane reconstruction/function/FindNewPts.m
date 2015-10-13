function [ newpts,oldind ] = FindNewPts( pts,oldpts )
%find new points that does not exist in old pts
% 3/12/2015 Yao Zhao



newpts=[];
oldind=zeros(size(newpts,1),1);
for i=1:size(pts,1)
    findold=0;
    for j=1:size(oldpts,1)
        if norm(pts(i,:)-oldpts(j,:))<1e-30
            findold=1;
            break;
        end
    end
    if findold==0
        newpts=[newpts;pts(i,:)];
        oldind(i)=0;
    else
        oldind(i)=j;
    end
end
    

end

