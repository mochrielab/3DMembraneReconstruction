function [ bwfilter ] = SurfaceFilter( bw,v1 )
% from 3d semi canny filter, construct surface
% find all groups of regions, and choose the largest one
% used to remove noise points
% 3/12/2015 Yao Zhao

%%
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
% get normal direction of each direction, x,y,z increment
dirnormal=cell(size(inddiff,1),1);
for i=1:length(dirnormal)
    dirnormal{i}=inddiff(abs(inddiff*inddiff(i,:)')==0,:);
end

%%
bwleft=bw;
numbw=0;
bws=[];

while sum(bwleft(:))>0
    % get all left points
    [py0,px0,pz0]=ind2sub(size(bw),find(bwleft==1));
    % choose first one
    ix0=px0(1);
    iy0=py0(1);
    iz0=pz0(1);
    bwleft(iy0,ix0,iz0)=0;
    % start new surface with that vertex
    bwsurf=zeros(size(bw));
    bwsurf(iy0,ix0,iz0)=1;
    bwsurfnewadded=bwsurf;
    numbw=numbw+1;
%     % creat a edge matrix to store how many connected points
%     edcount=zeros(size(bw));
    % add points to surface
    while sum(bwsurfnewadded(:))>0 %search when points added to bwsurf in last loop
        % get all the points added in last loop
        [py,px,pz]=ind2sub(size(bw),find(bwsurfnewadded==1));
        % reset saving of newly added point
        bwsurfnewadded=zeros(size(bw));
        % go through each newly added point
        for i=1:length(py)
            % get face normal at each point
            ix=px(i);iy=py(i);iz=pz(i);
            dirtmp=v1{iy,ix,iz};
            [~,maxind]=max(dirmat*dirtmp);
            % get dir parrellel to surface
            vals=dirmat*dirtmp;
%             incn=dirnormal{maxind};
            incn=inddiff(abs(vals)<0.5,:);
            bwnormal=zeros(3,3,3);
            bwnormal(sub2ind([3 3 3],2+incn(:,2),2+incn(:,1),2+incn(:,3)))=1;
%             % add edge count to edcount
%             edcind=sub2ind(size(bw),iy+incn(:,2),ix+incn(:,1),iz+incn(:,3));
%             edcount(edcind)=edcount(edcind)+1;
            % get unused neighboring point
            bwneighbor=bwleft(iy-1:iy+1,ix-1:ix+1,iz-1:iz+1);
            % add new points to the surface, that is unused neighbor and
            % parrellel to the surface
            [ady,adx,adz]=ind2sub([3,3,3],find(bwnormal & bwneighbor));
            adpx=ix+adx-2;
            adpy=iy+ady-2;
            adpz=iz+adz-2;
            addind=sub2ind(size(bw),adpy,adpx,adpz);
            bwsurf(addind)=1;
            bwsurfnewadded(addind)=1;
            % remove added vertex from pool
            bwleft(addind)=0;
        end
    end
    bws=[bws,{bwsurf}];
end

[~,maxind]=max(cellfun(@(x)sum(x(:)),bws));
bwfilter=bws{maxind};
%%
%  PlotRawSurface( l1,v1,bwfilter,zxr)
[ pts,faces ] = PlotVolCubes( bwfilter );
p.vertices=pts;
p.faces=faces;
patch(p,'FaceColor','r');
view(3);
camlight;
lighting gouraud;
axis equal
end

