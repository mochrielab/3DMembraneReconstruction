function [param] = getCorrelation(obj,img,template)
% get correlation to the template
% only works for 2d
% 11/19/2015 Yao Zhao

if length(size(img))>3
    warning('use getCorrelations');
end
fullcorrelation=normxcorr2(template,img);
csize=size(img)-size(template);
hcsize=(csize)/2;
c=fullcorrelation(size(template,1)+(0:csize(1)),size(template,2)+(0:csize(2)));
[x,y]=meshgrid(1:size(c,2),1:size(c,1));
options=optimoptions('fmincon','MaxFunEvals', 1e10,'TolX',.0001,...
    'Algorithm','trust-region-reflective','GradObj','on','Display','off');
gaussn=@(p)CellVision3D.Fitting.NGaussian2D0B(p,x,y,c);
init=[hcsize(1)+1,hcsize(2)+1,0.677*sqrt(sum(c(:)>max(c(:))/2)),...
    max(c(hcsize(1)+1,hcsize(2)+1)*0.9,0.09)];
lb= [init(1:2)-obj.maxdisp,0.01,0];
ub= [init(1:2)+obj.maxdisp,10,max(1.1*max(c(:)),0.1)];
p=fmincon(gaussn, init,[],[],...
    [],[],lb,ub,[],options);
param=p;
end