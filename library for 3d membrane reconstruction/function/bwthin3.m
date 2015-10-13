function [ bw2,L2 ] = bwthin3( bw0,varargin )
% thin the 3d images to surface
% only closed up surface can be identified
% will remove open surface
% 3/12/2015 Yao Zhao
% 3/18/2015 added the order of erosion to help smooth the contour

%%
n=inf;
if nargin>1
    n=varargin{1};
end

numconnection=26;

% extend bw image
bw=false(size(bw0)+2);
bw(2:end-1,2:end-1,2:end-1)=bw0;

% label image into several parts
L = bwlabeln(1-bw,6);

L2=zeros(size(bw));
L2(bw)=0;
L2(L==1)=1;
%number of major region (bw/L==0 doesnt count)
numregion=1;
%go search major region
for labeli =2:max(L(:))
    % if hole is large enough label it as a region
    if sum(L(:)==labeli)>= 5;
        numregion=numregion+1;
        L2(L==labeli)=numregion;
        % if hole not big enough set it as filled
    else
        L2(L==labeli)=0;
    end
end

% counting image
% EdgeL=repmat({zeros(size(bw0)+2)},numregion);
%     EdgeL{ilabel}=edge3(L2==ilabel,6);

% this case treat all inner area same
L2(L2>2)=2;
% iterate to thin the boundary until end
numerode=1;
iter=0;
while numerode>0 && iter<n
    iter=iter+1;
    % find out side and insde space to erode
    [EdgeOut,ImgOut]=edge3(L2==1,numconnection);
    [EdgeIn,ImgIn]=edge3(L2>1,numconnection);
    OutErode = EdgeOut & -EdgeIn;
    InErode = EdgeIn & -EdgeOut;
    % erode the max at first, this will help contour to be more smoothed
    % consider using same max for in and out?
    % 3/18/2015
    % this part is bugged, can't find why, very slow processing
%     ImgOut(~OutErode)=0;
%     ImgIn(~InErode)=0;
%     OutErode= ImgOut==max(ImgOut(:)) & ImgOut>0;
%     InErode= ImgIn==max(ImgIn(:)) & ImgIn>0;
    % check if done erosion
    numerode=sum(OutErode(:))+sum(InErode(:));
    L2(OutErode)=1;
    L2(InErode)=2;
end

bw2=L2==0;
bw2=bw2(2:end-1,2:end-1,2:end-1);
L2=L2(2:end-1,2:end-1,2:end-1);
end
