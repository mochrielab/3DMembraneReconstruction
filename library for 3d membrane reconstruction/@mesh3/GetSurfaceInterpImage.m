function [ obj ] = GetSurfaceInterpImage( obj )
%interpolate the original image to the surface shell
% 3/12/2015 Yao Zhao

%%

% initialize
pts=obj.vertices;
vertexnormals=obj.vertexnormals;
numpts=size(pts,1);
zxr=obj.zxr;

% scale back pts and vertexnormals zxr ratio
pts(:,3)=pts(:,3)/zxr;
vertexnormals(:,3)=vertexnormals(:,3)/zxr;

% extend image by the thickness of shell
imgsz=size(obj.image);
imgext=ceil(obj.shellstep*obj.shellstepnum);
img=zeros(imgsz+imgext*2);
imgsz=size(img);
img(1+imgext:end-imgext,1+imgext:end-imgext,1+imgext:end-imgext)=obj.image;

% shell sample scale
rs=(-obj.shellstepnum:obj.shellstepnum)'*obj.shellstep;
numrs=length(rs);

% surface image
shellimg=zeros(numrs,numpts);

% eight node increment
inc=[0 0 0; 0 0 1; 0 1 0; 0 1 1;...
     1 0 0; 1 0 1; 1 1 0; 1 1 1];

% loop through each point
for ipts=1:numpts
    ptmp=ones(numrs,1)*pts(ipts,:)+ rs*vertexnormals(ipts,:)+imgext;
    fp=floor(ptmp);
    dp=ptmp-fp;
    tmpImg=zeros(numrs,1);
    for iinc=1:8;
        inctmp=inc(iinc,:);
        ptmp=fp+ones(numrs,1)*inctmp;
        tmpImg=tmpImg+img(sub2ind(imgsz,ptmp(:,2),ptmp(:,1),ptmp(:,3))) ...
            .*prod((1-dp).*(ones(numrs,1)*(1-inctmp))+dp.*(ones(numrs,1)*inctmp),2);
    end
    shellimg(:,ipts)=tmpImg;
end

obj.shellimage=shellimg;

%%
% % fit each line with a gaussian function
% x0=(1:numrs)';
% for ipts=1:numpts
%     tmpImg=shellimg(:,ipts);
%     [maximg,maxind]=max(tmpImg);
%     p0=[maxind,2,maximg];
%     lb=[1,0,0];
%     ub=[numrs,numrs,1];
%     options = optimoptions('fmincon','MaxFunEvals',3000,'GradObj','on','display','off');
%     fmin=@(p)MinGaussian1D0B(p,x0,tmpImg);
%     p = fmincon(fmin,p0,[],[],[],[],lb,ub,[],options);
% end

%% fit them all
% tic
% x0=(1:numrs)'*ones(1,numpts);
%     [maximg,maxind]=max(shellimg,[],1);
%     p0=[maxind;2*ones(1,numpts);maximg];
%     lb=[1,0,0]'*ones(1,numpts);
%     ub=[numrs,numrs,1]'*ones(1,numpts);
% %     lb=[];
% %     ub=[];
%     options = optimoptions('fmincon','MaxFunEvals',1e8,'GradObj','on','display','iter');
%     fmin=@(p)MinGaussian1D0B(p,x0,shellimg);
%     p = fmincon(fmin,p0,[],[],[],[],lb,ub,[],options);
% toc

%% show the fit
% gauss1d0b=@(p,x) p(3)*exp(-((x-p(1))/p(2)).^2);
% for ipts=1:numpts
%     
%     clf;
%     plot(1:numrs,shellimg(:,ipts),'o');hold on;
%     plot(1:numrs,gauss1d0b(p(:,ipts),1:numrs));
%     axis([1 numrs 0 1])
%     pause
% end

%%
% SI(shellimg);hold on;plot(1:numpts,maxind);
end

