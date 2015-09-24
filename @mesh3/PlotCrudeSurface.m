function [  ] = PlotCrudeSurface( obj)
%plot raw image
% 3/12/2015 Yao Zhao

%%
[ l1,v1,l2,v2,l3,v3 ] = DirectionalLaplacian( obj.image);
bw=obj.bwsurf;%(2:end-1,2:end-1,2:end-1);
% not using zxr
zxr=1;

size(l1)
size(bw)
[rs,cs,ks]=ind2sub(size(l1),find(bw==1));
pos=[rs,cs,ks];
pos=pos(rs>1&rs<size(bw,1)&cs>1&cs<size(bw,2)&ks>1&ks<size(bw,3),:);
rs=pos(:,1);
cs=pos(:,2);
ks=pos(:,3);
v=zeros(size(pos));
for i=1:length(rs)
    ir=rs(i);
    ic=cs(i);
    ik=ks(i);
    v(i,:)=v1{ir,ic,ik};
end

plot3(cs,rs,ks,'o');hold on;
quiver3(cs,rs,ks,v(:,1),v(:,2),v(:,3)/zxr,...
    'AutoScaleFactor',.5,'ShowArrowHead','off','Color','r');hold on;
quiver3(cs,rs,ks,-v(:,1),-v(:,2),-v(:,3)/zxr,...
    'AutoScaleFactor',.5,'ShowArrowHead','off','Color','r');hold on;
daspect([1 1 1/zxr])
axis([1 size(obj.image,2) 1 size(obj.image,1) 1 size(obj.image,3)]);
end

