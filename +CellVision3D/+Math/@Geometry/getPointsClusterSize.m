function [ th ] = getPointsClusterSize( peaks,varargin )
% find a distance threshold to split a set of points that have some
% inherete grouping
% can be used to group same fluorescent particles that belong to the same
% cell
% this is a binary threshold that split the double log histogram of pair
% distance
% 3/24/2016 Yao Zhao

% set the z to x ratio
if nargin ==1
    zxr=1;
elseif nargin ==2
    zxr = varargin{1};
else
end


% get the distance between each 2 particles
numparticles=size(peaks,1);
d2mat=zeros(numparticles);
for i=1:numparticles
    for j=1:numparticles
        d2mat(i,j)=CellVision3D.Math.Geometry.getDistance...
            (peaks(i,:),peaks(j,:),zxr);
    end
end

% calculate the log distance
d2=d2mat(:);
logd2=log(d2(d2>0));

% calculate the distribution
maxlogd2=max(logd2);
bins=linspace(1,maxlogd2,40);
logcounts=log(hist(logd2,bins)+1);
maxcounts=max(logcounts);

% fit it two a two peak gaussian
ini=[1.1 maxlogd2/8 maxcounts/2; ...
    maxlogd2-1 maxlogd2/8 maxcounts/2];
lb = [1 0.1 maxcounts/100;...
    2 0.1 maxcounts/100];
ub = [maxlogd2-1 maxlogd2/2 maxcounts*1.5; ...
    maxlogd2 maxlogd2/2 maxcounts*1.5];
options=optimoptions('fmincon','Display','off');
% forcing that second peak is bigger

% start fitting
p=fmincon(@(p)CellVision3D.Fitting.NGaussian1D0B(p,bins,logcounts),...
    ini,[],[],[],[],...
    lb,ub,@(p)lncon(p),options);

    function [ c, ceq] = lncon(p)
        c=p(1,1)-p(2,1);
        ceq=0;
    end

% get fitted curve
[~,~,fval]=CellVision3D.Fitting.NGaussian1D0B(p,bins,logcounts);

% find the value that is the smallest between peaks
dbins=bins(2)-bins(1);
startbin=ceil((p(1,1)-bins(1))/dbins);
endbin=floor((p(2,1)-bins(1))/dbins);
[~, thlogd2] = min(fval(startbin:endbin));
th = exp(bins(thlogd2+startbin));

% % plot fitting result
% bar(bins,logcounts); hold on;
% plot(bins,fval,'linewidth',2);

end

