function [param,resnorm,exitflag] = Gaussian2DFit(img,cnt,wsize,ini,lb,ub,options,showplot)
% use 2D gaussian to fit all centroid
% [parameters2,resnorm,exitflag] = Gaussian2DFit(img2,centroid,constraints,showplot)
% constraints: (1) scale= window size (2) max displacement (3) max size
% parameters2  cx cy sigma bg peakI

%initial
numberoffit=size(cnt,1);
param=zeros(numberoffit,5);
exitflag=zeros(numberoffit,1);
resnorm=zeros(numberoffit,1);

if mod(wsize,2)==0
    error('window size need to be odd number');
end

[X,Y] = meshgrid(1:wsize,1:wsize);
cw=(wsize+1)/2;
hw=(wsize-1)/2;
if isempty(options)
options = optimset('Algorithm','trust-region-reflective','TolX',1e-8,'Display','Off','MaxIter',1e4,'MaxFunEvals',1e3);
end
if isempty(ini)
    inia=[0,0,0,0,0];
else
    inia=ini;
end
if isempty(lb)
    lba=[0 0 0 0 0];
else
    lba=lb;
end
if isempty(ub)
    uba=[wsize,wsize,wsize*2,65535,65535];
else
    uba=ub;
end

%fit each gaussian
for i=1:numberoffit
    %smaller window
    cx = cnt(i,1);
    cy = cnt(i,2);
    mx=round(cx);
    my=round(cy);
    rx=cx-mx;
    ry=cy-my;
    mxy = img(my-hw:my+hw,mx-hw:mx+hw); 
    %adjust initial condition
    lba(1:2)=lb(1:2)+[cw+rx,cw+ry];
    uba(1:2)=ub(1:2)+[cw+rx,cw+ry];
    inia(1:2)=ini(1:2)+[cw+rx,cw+ry];
    %gauss func fitting
    Gauss2D=@(p,x,y,z) Gaussian2D(p,x,y)-z;
    %     [parameters,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA,JACOBIAN] = ...
    %         lsqnonlin(Gauss2D,initpar,lowpar,highpar,options,X,Y,mxy);
    [parameters,resnorm(i),~,exitflag(i),~,~,~] = ...
        lsqnonlin(Gauss2D,inia,lba,uba,options,X,Y,mxy);
    resnorm(i)=resnorm(i)/mean(mxy(:))^2/size(mxy,1)/size(mxy,2);
    if showplot == 1
        figure(234234);clf
        subplot(2,1,1); surf(mxy);
        subplot(2,1,2);
        contour3(mxy,'--');
        colormap cool
        hold on;
        contour3(Gaussian2D(parameters,X,Y),'-');
                 pause(.1)
    end
    param(i,:)=parameters;
    param(i,1) = parameters(1) + mx - cw;
    param(i,2) = parameters(2) + my - cw;
end