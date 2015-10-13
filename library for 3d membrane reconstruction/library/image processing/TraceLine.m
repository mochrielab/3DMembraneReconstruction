function [ pos ] = TraceLine( bw )
%Trace line in bw image; bw has to have only one connected image;
%%
bw1=bw;
img1=conv2(double(bw1),ones(3,3),'same');
branchingimg=(img1>=4)&bw1;
if sum(branchingimg(:))>0
    warning('image has branching points');
    pos=[];
else
    startimg=(img1==2)&bw1;
    startind=find(startimg);
    [sy,sx]=ind2sub(size(bw1),startind);
    
    
    px=sx(1);
    py=sy(1);
    pos=[sx(1),sy(1)];
    while px~=sx(2) || py~=sy(2)
        bw1(py,px)=0;
        [r,c]=find(bw1(py-1:py+1,px-1:px+1));
        py=py+r-2;
        px=px+c-2;
        pos=[pos;px,py];
    end
    % SI(bw);hold on;plot(pos(:,1),pos(:,2))
end
end

