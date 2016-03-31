function [ bwedge ] = getSurfEdge( bw, v1, dirth)
%find edge of the image with constraints that edge point is at least dirth
%distant away from the face normal
% 3/12/2015 Yao Zhao

% 26 direction
dirmat=[];
inddiff=[];
for ix=-1:1
    for iy=-1:1
        for iz=-1:1
            if ~(ix==0 && iy==0 && iz==0)
                dirmat=[dirmat; [ix iy iz]/norm([ix iy iz])];
                inddiff=[inddiff;[ix iy iz]];
            end
        end
    end
end

bwedge=zeros(size(bw));
[rs,cs,ks]=ind2sub(size(bw),find(bw==1));
pos=[rs,cs,ks];
pos=pos(rs>1&rs<size(bw,1)&cs>1&cs<size(bw,2)&ks>1&ks<size(bw,3),:);
rs=pos(:,1);
cs=pos(:,2);
ks=pos(:,3);

for i=1:length(rs)
    ir=rs(i);
    ic=cs(i);
    ik=ks(i);
    dirtmp=v1{ir,ic,ik};
%     dirtmp(3)=dirtmp(3)*zxr;
    goodind=find(abs(dirmat*dirtmp)<dirth);
    bwedge(sub2ind(size(bw),ir+inddiff(goodind,2),...
        ic+inddiff(goodind,1),ik+inddiff(goodind,3)))=1;
end
bwedge=bwedge-bw;
end

