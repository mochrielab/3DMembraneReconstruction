function [] = WholePlot(oimg,bimg,p1,zxr)
% zxr=obj.vox/obj.pix;
% th=obj.pkfndparam.th;

% p1=obj.particle;
% oimg=obj.grab3(1);
% bimg=bpass3(oimg,obj.filterparam.lnoise,obj.filterparam.lobject,zxr);

sath=.3*max(oimg(:));
satoimg=oimg;
satoimg(satoimg>sath)=sath;
bg=bpass3(satoimg,3,0,zxr);
% bg=zeros(obj.sizeY,obj.sizeX,obj.sizeZ);
%     for istack=1:obj.numstacks
%         img=obj.grab(1,istack);
%         bg(:,:,istack) = imopen(img,strel('disk',5));
% %         fimg(:,:,istack)=img-bg;
% %         oimg(:,:,istack)=img;
%     end

[pairs] = Group3DPoints(p1,13,[]);
p2=[];
for i=1:length(pairs)
    ptmp=sortrows(pairs{i},6);
    bright=zeros(size(ptmp,1),1);
    bright(end)=1;
    p2=[p2;ptmp,bright];
end

% figure
% Ib=p2(p2(:,7)==1,6);
% Id=p2(p2(:,7)==0,6);
% [b1,c1]=hist(Ib);
% [b2,c2]=hist(Id);
% bar(c1,b1,c2,b2);
% 1
% pause

v=bimg;
pat=isosurface(v,.09*max(v(:)));
pat=patch(reducepatch(pat,.3),'FaceColor','blue','EdgeColor','none','FaceAlpha',.4);
% isonormals(v,pat);

v=bg;
pat=isosurface(v,.5*max(v(:)));
pat=patch(reducepatch(pat,.3),'FaceColor','yellow','EdgeColor','none','FaceAlpha',.1);
% isonormals(v,pat);

hold on;
p=p2;
for j=1:size(p,1)
    [x, y, z] = ellipsoid(p(j,1),p(j,2),p(j,3),p(j,4)/2,p(j,4),p(j,5),30);
    if p(j,7)==1
    surf(x, y, z, 'FaceColor','red','EdgeColor','none')
    else
            surf(x, y, z, 'FaceColor','green','EdgeColor','none')
    end
%     shading interp
%     colormap(red);
%     axis equal;
end

daspect([1,1,1/zxr])
view(3);
axis([1 size(v,1) 2 size(v,2) 3 size(v,3)])
camlight
lighting gouraud

% end

