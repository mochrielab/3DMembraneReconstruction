function [ strongpts ] = getEigenSecondDerivativesEdge(img,th)
%suppress the non max region
% 3/12/2015 Yao Zhao


[ l1,v1,l2,v2,l3,v3 ] = CellVision3D.ImageSegmenterFluorescentMembrane3D...
    .getEigenSecondDerivatives( img );

%% direction threshold
dirth=th(3);

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

% %6 direction
% dirmat=[ 0 0 1;
%          0 0 -1;
%         0 1 0;
%         0 -1 0;
%         1 0 0;
%         -1 0 0];
% inddiff=dirmat;
tic
% start image mask
ll1=img.*l1;
ll2=abs(img.*l2);
ll3=abs(img.*l3);
mask23= ll2<0.1*max(ll2(:)) & ll3<0.1*max(ll3(:));
% find above threshold
bwweak = ll1< th(1)* min(ll1(:)) .* mask23;  % strong edge
bwstrong=ll1< th(2) * min(ll1(:)) .* mask23;   %weak edge
% find strong edge point
bw2=zeros(size(bwweak));
[rs,cs,ks]=ind2sub(size(ll1),find(bwweak==1));
% filter border points
pos=[rs,cs,ks];
pos=pos(rs>1&rs<size(bwweak,1)&cs>1&cs<size(bwweak,2)&ks>1&ks<size(bwweak,3),:);
rs=pos(:,1);
cs=pos(:,2);
ks=pos(:,3);
size(rs)
%local maxium selection
inc=inddiff;
for i=1:length(rs)
    ir=rs(i);
    ic=cs(i);
    ik=ks(i);
    dirtmp=v1{ir,ic,ik};
%     dirtmp(3)=dirtmp(3)*zxr;
    goodind=find(dirmat*dirtmp<-dirth);
    posvalue=ll1(sub2ind(size(bwweak),ir+inc(goodind,2),...
        ic+inc(goodind,1),ik+inc(goodind,3)));
    negvalue=ll1(sub2ind(size(bwweak),ir-inc(goodind,2),...
        ic-inc(goodind,1),ik-inc(goodind,3)));
    bw2(ir,ic,ik)= ll1(ir,ic,ik)<mean(posvalue) && ll1(ir,ic,ik)<mean(negvalue);
end
display('local maximum find');
toc
%%
% remove weak edges
strongpts=bw2 & bwstrong;
weakpts= bw2 & ~strongpts;
addweak = CellVision3D.ImageSegmenterFluorescentMembrane3D.getSurfEdge( strongpts, v1, dirth) & weakpts;
while sum(addweak(:))>0
    strongpts = strongpts | addweak;
    weakpts = weakpts & ~addweak;
    addweak = CellVision3D.ImageSegmenterFluorescentMembrane3D.getSurfEdge( strongpts, v1, dirth) & weakpts;
end


end

