function generateTemplate(obj, img3)
% generate template for dirft control
% 11/19/2015 Yao zhao

% crop image
cnt=obj.centroid;
hs=(obj.windowsize-1)/2;
wimg3=CellVision3D.Image3D...
    .crop(img3,[cnt(2)-hs,cnt(2)+hs,cnt(1)-hs,cnt(1)+hs,1,size(img3,3)]);
% border of template
bordermargin=(obj.correlationwindowsize-1)/2;
numstacks=size(wimg3,3);
maxparam=zeros(1,numstacks);
% try all template
for itemplate=1:numstacks
    template=wimg3(1+bordermargin:end-bordermargin,...
        1+bordermargin:end-bordermargin,itemplate);
    param=obj.getCorrelations(wimg3,template);
    plot((1:numstacks)*0.2,param(:,4),'o-');hold on;pause(.1);
    maxparam(itemplate)=max(param(:,4));
end
% choose the right one
[~,templateind]=min(maxparam);
templateind=templateind+4;
obj.template=wimg3(1+bordermargin:end-bordermargin,...
    1+bordermargin:end-bordermargin,templateind);


end