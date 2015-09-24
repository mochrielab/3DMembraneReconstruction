% generating pictures for the paper

%% image for nup85
nup85=mitosis(fullfile('C:\Users\Yao\Google Drive\Movie for analysis\052915','nup85_GFP_04_R3D.dv'));
% load movie first 100 frames
nup85.loadmovie(1*25);
img3=nup85.grab3(1);
% SI(img3(:,:,14));
wz=15;
wimg3=img3(271+(-wz:wz),406+(-wz:wz),:);
% ImgViewer3D(wimg3)
% SI(squeeze(sum(wimg3,3)))
figure('Position',[2000 0 1000 1000]);axes('Position',[0 0 1 1])
SI((wimg3(end:-1:1,:,15)));
    l=1/0.16;
    rectangle('Position',[2*wz+1-l-2,2*wz+1-2,l,1],'FaceColor','w')
axis off;
savefigure('nup85raw');
%% mesh for nup85
%get mesh
obj=mesh3(wimg3,nup85.zxr);
obj.diagnostic_mod_on=1;
obj.cost=.5;
display('initialize mesh');
tic
obj.InitializeMesh;
% obj.PlotMeshSim;
toc

display('optimize mesh');
tic
obj.OptimizeMesh;
obj.LabelPatchId;
obj.AlignFaceDirection;
obj.GetVertexNormalDirection;
toc

display('fit surface');
tic
obj.FitSurface;
toc
obj.vertices=obj.vertices-5*ones(size(obj.vertices,1),1)*[1 1 obj.zxr];
figure('Position',[2000 0 1000 1000]);axes('Position',[0 0 1 1])
SP(obj,'r','none'); camlight; lighting gouraud;
axis([0 size(wimg3,1) 0 size(wimg3,2) 0 size(wimg3,3)]);
axis off;
view([0 0 1])
savefigure('nup85_3dmesh');

%%
% plot fit contour
mean(obj.vertices(:,3)/obj.zxr)
figure('Position',[2000 0 1000 1000]);axes('Position',[0 0 1 1])
[allcontours,lowerfaces,lowerpts]=obj.GetCrossSection([0 0 1 15*obj.zxr]);
SI(wimg3(end:-1:1,:,15));hold on;
l=1/0.16;
rectangle('Position',[2*wz+1-l-2,2*wz+1-2,l,1],'FaceColor','w')
axis off;
for i=1:length(allcontours)
    c=allcontours{i};
    plot(c(:,1),2*wz+2-c(:,2),'r');hold on;
end
FigureFormat(gcf);
savefigure('nup85_fit');

%% image for clo3
clo3=mitosis(fullfile('C:\Users\Yao\Google Drive\Movie for analysis\052915','clo3_GFP_02_R3D.dv'));
% load movie first 100 frames
clo3.loadmovie(1*25);
img3=clo3.grab3(1);
SI(img3(:,:,13));
wz=25;
wimg3=img3(345+(-wz:wz),433+(-wz:wz),:);
% wimg3=img3(228+(-wz:wz),379+(-wz:wz),:);
% ImgViewer3D(wimg3)
% SI(squeeze(sum(wimg3,3)))
figure('Position',[2000 0 1000 1000])
SI(wimg3(end:-1:1,:,15))
axis off;
    l=1/0.16;
    rectangle('Position',[2*wz+1-l-2,2*wz+1-2,l,1],'FaceColor','w')
savefigure('clo3raw');
%% mesh for clo3 inner
%get mesh
% th=ImgTh(wimg3,.9);
% wimg31=wimg3;
% wimg31(wimg3<th)=0;
obj1=mesh3(wimg3,clo3.zxr);
obj1.preprocessth=[.1 5 .980];
obj1.cannyth=[.6, .2, .5];
obj1.diagnostic_mod_on=1;
obj1.cost=1;
display('initialize mesh');
tic
obj1.InitializeMesh;
obj1.PlotMeshSim;
toc

display('optimize mesh');
tic
obj1.OptimizeMesh;
obj1.LabelPatchId;
obj1.AlignFaceDirection;
obj1.GetVertexNormalDirection;
toc

display('fit surface');
tic
obj1.FitSurface;
toc
obj1.vertices=obj1.vertices-5*ones(size(obj1.vertices,1),1)*[1 1 obj1.zxr];

%% outer cell
obj2=mesh3(wimg3,clo3.zxr);
obj2.preprocessth=[.1 5 .8];
obj2.cannyth=[.8, .2, .9];
obj2.diagnostic_mod_on=1;
obj2.cost=1;
display('initialize mesh');
tic
obj2.InitializeMesh;
toc

display('optimize mesh');
tic
obj2.mesh_size=5;
obj2.OptimizeMesh;
obj2.LabelPatchId;
obj2.AlignFaceDirection;
obj2.GetVertexNormalDirection;
toc

display('fit surface');
tic
obj2.FitSurface;
toc
obj2.vertices=obj2.vertices-5*ones(size(obj2.vertices,1),1)*[1 1 obj2.zxr];

%% plot clo3 mesh two
figure('Position',[2000 0 1000 1000])
SP(obj1,'r','none',1); hold on;
SP(obj2,'b','none',.5); camlight; lighting gouraud;
axis([0 size(wimg3,1) 0 size(wimg3,2) 0 size(wimg3,3)*obj2.zxr]);
axis off; hold on;
view([0 0 1])
savefigure('clo3_3dmesh');
%%  plot fit contour

% obj.vertices=obj.vertices-5;
mean(obj.vertices(:,3)/obj.zxr)
figure('Position',[2000 0 1000 1000]);axes('Position',[0 0 1 1])
[allcontours1,lowerfaces,lowerpts]=obj1.GetCrossSection([0 0 1 15*obj1.zxr]);
[allcontours2,lowerfaces,lowerpts]=obj2.GetCrossSection([0 0 1 15*obj2.zxr]);
SI(wimg3(end:-1:1,:,15));hold on;
l=1/0.16;
rectangle('Position',[2*wz+1-l-2,2*wz+1-2,l,1],'FaceColor','w')
axis off;
for i=1:length(allcontours1)
    c1=allcontours1{i};
    c2=allcontours2{i};
    plot(c1(:,1),2*wz+2-c1(:,2),'r');hold on;
    plot(c2(:,1),2*wz+2-c2(:,2),'b');hold on;
end
FigureFormat(gcf);
savefigure('clo3_fit');


%% image for mitotic
rootpath='C:\nuclei';
moviename='wild_type_04.dv';
mt=mitosis(fullfile(rootpath,moviename));
% load movie first 100 frames
mt.loadmovie(100*10);% load movie first 100 frames
img3=mt.grab3(50);
istack=6;
SI(img3(:,:,istack));
wz=25;
wimg3=img3(157+(-wz:wz),165+(-wz:wz),:);
% ImgViewer3D(wimg3)
% SI(squeeze(sum(wimg3,3)))
figure('Position',[2000 0 1000 1000]);axes('Position',[0 0 1 1])
SI((wimg3(end:-1:1,:,istack)));
    l=1/0.16;
    rectangle('Position',[2*wz+1-l-2,2*wz+1-2,l,1],'FaceColor','w')
axis off;
savefigure('mtraw');
%% mesh for nup85
%get mesh
obj=mesh3(wimg3,mt.zxr);
obj.diagnostic_mod_on=1;
obj.cost=.5;
display('initialize mesh');
tic
obj.InitializeMesh;
% obj.PlotMeshSim;
toc

display('optimize mesh');
tic
obj.OptimizeMesh;
obj.LabelPatchId;
obj.AlignFaceDirection;
obj.GetVertexNormalDirection;
toc

display('fit surface');
tic
obj.FitSurface;
toc
obj.vertices=obj.vertices-5*ones(size(obj.vertices,1),1)*[1 1 obj.zxr];
figure('Position',[2000 0 1000 1000]);axes('Position',[0 0 1 1])
SP(obj,'r','none'); camlight; lighting gouraud;
axis([0 size(wimg3,1) 0 size(wimg3,2) 0 size(wimg3,3)*obj.zxr+1]);
axis off;
view([0 0 1])
savefigure('mt_3dmesh');

%%
% plot fit contour
mean(obj.vertices(:,3)/obj.zxr)
figure('Position',[2000 0 1000 1000]);axes('Position',[0 0 1 1])
[allcontours,lowerfaces,lowerpts]=obj.GetCrossSection([0 0 1 istack*obj.zxr]);
SI(wimg3(end:-1:1,:,istack));hold on;
l=1/0.16;
rectangle('Position',[2*wz+1-l-2,2*wz+1-2,l,1],'FaceColor','w')
axis off;
for i=1:length(allcontours)
    c=allcontours{i};
    plot(c(:,1),2*wz+2-c(:,2),'r');hold on;
end
FigureFormat(gcf);
savefigure('mt_fit');


%% get picture from
close all;
clear all;
clc;
% set location of dv movies
rootpath='C:\nuclei';
moviename='wild_type_04.dv';
mt=mitosis(fullfile(rootpath,moviename));
% load movie first 100 frames
mt.loadmovie(100*10);
%% get windowed image
zxr=mt.vox/mt.pix*mt.aberation;
iframe=1;
img3=mt.grab3(iframe);
wimg3=img3(247:298,290:341,:);

% save raw image type
clf
figure('Position',[2000 0 1000 1000])
axes('Unit','Pixel','Position',[0 0 1000 1000]);
imagesc(wimg3(:,:,5));colormap gray; axis image;
axis off;
name='rawnuclei';
savefigure(name)
close all;

% save vocano type at [azu = 90, el = 70]
clf
figure('Position',[2000 0 1000 1000])
axes('Unit','Pixel','Position',[0 0 1000 1000]);
surf(wimg3(:,:,5)/max(max(wimg3(:,:,5))) )
axis off;
view([90 70])

name='vocanonuclei';
savefigure(name)
close all;

%% get mesh
obj=mesh3(wimg3,zxr);
obj.diagnostic_mod_on=0;
obj.cost=2;
%
display('initialize mesh');
tic
obj.InitializeMesh;
toc

display('optimize mesh');
tic
obj.OptimizeMesh;
toc
obj.PlotMeshSim;
obj.LabelPatchId;
obj.AlignFaceDirection;
obj.GetVertexNormalDirection;%     obj.PlotMeshStack(.5);
display('fit surface');
tic
obj.FitSurface;
toc
obj.PlotMeshSim

savefigure('3dmesh');

% get fit plot
obj.vertices(:,1:2)=obj.vertices(:,1:2)-5;
obj.vertices(:,3)=obj.vertices(:,3)-5*obj.zxr;
istack=round(mean(obj.vertices(:,3)/obj.zxr));
figure('Position',[2000 0 1000 1000]);axes('Position',[0 0 1 1])
[allcontours,lowerfaces,lowerpts]=obj.GetCrossSection([0 0 1 istack*obj.zxr]);
SI(wimg3(:,:,istack));hold on;
% SI(wimg3(end:-1:1,:,istack));hold on;
l=1/0.16;
rectangle('Position',[size(wimg3,1)-l-2,size(wimg3,1)-2,l,1],'FaceColor','w')
axis off;
for i=1:length(allcontours)
    c=allcontours{i};
%     plot(c(:,1),1+size(wimg3,1)-c(:,2),'r');hold on;
    plot(c(:,1),c(:,2),'r');hold on;
end
FigureFormat(gcf);
savefigure('nuc_fit');

%% simulated data intensity distribution
% load('simimg.mat');
close all
figure('Position',[2000 0 1000 1000])
simimg=SimulateZStacks( );
img1=wimg3(:,:,5);
img2=simimg(:,:,21);
% bins=0:0.01:1;
bins=0:0.1:5;
c1=hist(img1(:)/mean(img1(:)),bins);
c2=hist(img2(:)/mean(img2(:)),bins);
c1=c1/sum(c1);
c2=c2/sum(c2);
plot(bins,c1,bins,c2);
lh=legend('experimental image','simulated image');
lh.set('box','off');
xlabel('relative intensity');
ylabel('probability');
FigureFormat(gcf);
title('Image Intensity Distribution');
savefigure('intensitydistribution');


% compare real data and simulated cell
figure
SI(wimg3(:,:,5),simimg(:,:,26));
figure('Position',[2000 0 1000 1000])
imagesc(simimg(:,:,26));axis image;colormap gray;
axis off;
savefigure('simulatednuc');

%% nuclear fluctuation
amp=1.2;
[simimg,mesh,contour,meshnoise]=SimulateZStacks(amp);
figure('Position',[2000 0 1000 1000])
imagesc(simimg(:,:,26));axis image;colormap gray;hold on;
t=0:0.01:2*pi;
plot(7.5*cos(t)+26,7.5*sin(t)+26);hold on;
% r1=7.5+ amp*exp(-((cos(t)*cos(pi/8)+sin(t)*sin(pi/8)-1)*8).^2);
% r1=7.5+ amp./(1+(acos(cos(t)*cos(pi/8)+sin(t)*sin(pi/8))).^2/(pi/8)^2);
% plot(r1.*cos(t)+26,r1.*sin(t)+26);hold on;
plot(contour.x,contour.y);
axis off;
FigureFormat(gcf);
savefigure('simulatednucfluc');

%% choose parameter
obj=mesh3(simimg(1+5:end-5,1+5:end-5,1+5:end-5),1);
obj.cost=20/3;
obj.diagnostic_mod_on=0;
obj.InitializeMesh;
obj.OptimizeMesh;
obj.GetEdgesAndNeighbors
obj.LabelPatchId;
obj.AlignFaceDirection;
obj.GetVertexNormalDirection;
obj.FitSurface;
d=obj.CompareShape(mesh);
rmsd=mean(abs(d));
% rmserror(iobj)= std(abs(ds))/sqrt(length(ds));

%% plot parameter choose
close all
img=obj.image;
pts=obj.vertices;
faces=obj.faces;
vn=obj.vertexnormals;
rs=-5:.5:5;
rs2=-2.5:.5:2.5;
allIs=zeros(size(pts,1),length(rs2));
for ipts=1:size(pts,1)
    pos=ones(length(rs),1)*pts(ipts,:)+rs'*vn(ipts,:);
    Is=InterpImage(img,pos);
    rm=sum(Is.*rs')/sum(Is);
    allIs(ipts,:)=interp1(rs-rm,Is/mean(Is),rs2,'pchip');
%     plot(rs2,allIs(ipts,:));hold on;
end
meanI=mean(allIs,1);
stdI=std(allIs,1);
errorbar(rs2,meanI,stdI,'LineWidth',2);hold on;
c0=[0,meanI(6)];
plot([0 2],meanI(6)*[1 1],'r-.');hold on;
plot([0 2],(meanI(6)-stdI(6))*[1 1],'r-.');hold on;
plot([0 0]+0.62,[0 3.05],'r-.'); hold on;
% plot([0 0],[0 .5],'r-.');
text(1.5,3.3,'\DeltaI');
text(.15,.3,'\Deltar');
xlabel('pixels');
ylabel('Intensity');
FigureFormat(gcf);
savefigure('regularizationchoose');
%% simulated cell get errors
% cs=[exp(-4:2:10)];
% cs=[exp(-4:2:16)];
cs = [exp(-4:1.5:.5),5,9,15:15:90];
mean_error=zeros(size(cs));
total_error=zeros(size(cs));
obj=mesh3(simimg,1);
objs=repmat(obj,length(cs),1);
for ci = 1:length(cs)%exp(-1:1:3)
close all;
% obj=mesh3(simimg,1);
% obj.image=obj.rawimage;
obj=mesh3(simimg(1+5:end-5,1+5:end-5,1+5:end-5),1);
% obj.PreProcessImage;

obj.diagnostic_mod_on=0;
obj.cost=cs(ci);
obj.InitializeMesh;
obj.OptimizeMesh;

obj.GetEdgesAndNeighbors
obj.LabelPatchId;
obj.AlignFaceDirection;
obj.GetVertexNormalDirection;
% obj.PlotMeshSim;pause

obj.FitSurface;

close all
figure
SP(obj,'r','k',.5);
hold on;
SP(mesh,'b','none',.5);
view([0 0 1])
axis on
drawnow;
objs(ci)=obj;
% pause
end
save('objs.mat','objs');
% save('total_error','total_error');
%
rms=zeros(size(cs));
ms=zeros(size(cs));
rmserror=zeros(size(cs));
for iobj=1:length(objs)
    ds=objs(iobj).CompareShape(mesh);
%     rms(iobj)=sqrt(mean(ds.^2));
%     rmserror(iobj)= sqrt(std(ds.^2))/sqrt(length(ds));
    rms(iobj)=mean(abs(ds));
    rmserror(iobj)= std(abs(ds))/sqrt(length(ds));
%     rms(iobj)=std(ds);
%     ms(iobj)=mean(ds);
end

% %% show cell fit
% % plot fit contour
% cnt=round(mean(obj.vertices));
% figure('Position',[2000 0 1000 1000]);axes('Position',[0 0 1 1])
% [allcontours,lowerfaces,lowerpts]=obj.GetCrossSection([0 0 1 cnt(3)]);
% SI(obj.image(end:-1:1,:,cnt(3)));hold on;
% l=1/0.16;
% rectangle('Position',[2*wz+1-l-2,2*wz+1-2,l,1],'FaceColor','w')
% axis off;
% for i=1:length(allcontours)
%     c=allcontours{i};
%     plot(c(:,1),2*wz+2-c(:,2),'r');hold on;
% end
% FigureFormat(gcf);
% % savefigure('mt_fit');


%% reconstruction error
load('total_error.mat');
figure('Position',[2000 0 1000 1000])
semilogx(cs(1:end-0),rms(1:end-0)*160,'b'); hold on;
errorbar(cs(1:end-0),rms(1:end-0)*160,rmserror*160,'LineWidth',2);hold on;
% plot(6.67,21.79,'xg','MarkerSize',10);
plot([0 0]+6.67, [0 100],'.-r');
xlabel('regularization parameter')
ylabel('rms (nm)');
axis([0 100 20 70]);
title('root mean square error of membrane reconstruction');
FigureFormat(gcf);
savefigure('error');
%%  demo for noise
figure('Position',[2000 0 1400 1000])
x=0:0.01:1;
n0=0.1*abs(randn(size(x)));
s0= (x/0.5).^-4;
s1=s0+n0;
s2=(s1.*exp(-(x/0.3).^4));
sh=(s1.*exp(-(x/0.6).^4));
sl=(s1.*exp(-(x/1.2).^4));
% 
% s0=s0/sum(s0);
% s1=s1/sum(s1);
% s2=s2/sum(s2);

plot(x,s0,x,s1,x,s2,x,sh,x,sl)
legend('true shape','noise added shape measurement','proper bending energy',...
   'high bending energy','low bending energy');
xlabel('spatial frequency (arbitary unit)');
ylabel('arbitary unit');
title('Fourier Transfrom of the Shape');
axis([0 1 -0.05 1.3])
FigureFormat(gcf);
savefigure('spatialfrequency');
% nq0=0.05*randn(size(x));
% y2=max(s0+nq0,0);
% snr1=s0./n0;
% o1 = .1*(1-exp(-(x/0.5).^4));
% n1 = n0-o1;
% n1(n1<0)=0;
% s1 = s0-o1;
% s1(s1<0)=0;
% plot(x,s0,x,n0*ones(size(x)),x,s1,x,n1);
% legend('signal','noise','repressed signal','repressed noise');
%% snr
figure('Position',[2000 0 1400 1000])
for th=[0.3,0.6,1.2]
    cs=s0.*(1-exp(-(x/th).^4))
n=.2-cs;
n(n<0)=0;
n=sqrt(n.^2+ cs.^2);
% n=(n + (s0.*(1-exp(-(x/th).^4))));
snr=s0./n;
plot(x,snr);hold on;
end

legend('low bending energy',...
   'proper bending energy','high bending energy');
xlabel('spatial frequency (arbitary unit)');
ylabel('');
title('signal to noise ratio');
% axis([0 1 -0.05 1.3])
FigureFormat(gcf);
savefigure('snr');

% y2(y2<0)=-y2(y2<0);
% % y2 = 0.1*ones(size(x));
% figure(1)
% plot(x,s0,x,y2);
% figure(2)
% plot(x,snr1);

%% fluctuation accuracy

figure('Position',[2000 0 1400 1000])
x=1:10;
y=30*(1.2-1./(1+(x/5-1).^2))/.2
plot(x,y);
axis([0 11 0 100])
xlabel('regularization');
ylabel('error (nm)');
title('fluctuation measurement error');
% axis([0 1 -0.05 1.3])
FigureFormat(gcf);
savefigure('fluctuationerror');





