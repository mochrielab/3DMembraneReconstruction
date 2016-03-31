function [ bw3 ] = edgeCanny( img3,th)
% 3d canny edge filter
% threshold has to satisfy 0<th(1)<th(2)<1
% 3/30/2016 Yao Zhao

if th(1)>=th(2)
    error('first edge threshold has to be smaller than second');
end



% 26 direction
dirmat=[];
inddiff=[];
poshalf = logical([]);
rand_non_ortho = [.1 .2 .3]';
for ix=-1:1
    for iy=-1:1
        for iz=-1:1
            if ~(ix==0 && iy==0 && iz==0)
                dirmat=[dirmat; [ix iy iz]/norm([ix iy iz])];
                poshalf = [poshalf;[ix iy iz]*rand_non_ortho>0];
                inddiff=[inddiff;[ix iy iz]];
            end
        end
    end
end

% %6 direction
% dirmat=[ 0 0 1;
%          0 0 -1;
%         0 1 0;
%         0 -1 0;
%         1 0 0;
%         -1 0 0];
% inddiff=dirmat;

% get bw image of strong and weak
bwweak = img3>th(1);
bwstrong = img3>th(2);

% find all edge point
[rs,cs,ks]=ind2sub(size(img3),find(bwweak==1));
% filter border points
pos=[rs,cs,ks];
pos=pos(rs>1&rs<size(bwweak,1)&cs>1&cs<size(bwweak,2)...
    &ks>1&ks<size(bwweak,3),:);
rs=pos(:,1);
cs=pos(:,2);
ks=pos(:,3);

%local maxium selection of all edges
bw2=false(size(bwweak));
inc=inddiff;
for i=1:length(rs)
    ir=rs(i);
    ic=cs(i);
    ik=ks(i);
    halfvalues1=img3(sub2ind(size(bwweak),ir+inc(poshalf,2),...
        ic+inc(poshalf,1),ik+inc(poshalf,3)));
    halfvalues2=img3(sub2ind(size(bwweak),ir-inc(poshalf,2),...
        ic-inc(poshalf,1),ik-inc(poshalf,3)));
    bw2(ir,ic,ik)=sum(img3(ir,ic,ik)>halfvalues1 & img3(ir,ic,ik)>halfvalues2)>0;
end

display('local maximums found');

% remove weak edges
bw3=bw2 & bwstrong;
weakpts= bw2 & ~bwstrong;
addweak = CellVision3D.Image3D.edge(bw2,26) & weakpts;
while sum(addweak(:))>0
    bw3 = bw3 | addweak;
    weakpts = weakpts & ~addweak;
    addweak = CellVision3D.Image3D.edge(bw2,26) & weakpts;
end

%%
% CellVision3D.Image3D.view(bw3);


end

