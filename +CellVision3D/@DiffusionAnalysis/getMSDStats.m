function [meanMSD,seMSD]=getMSDStats(msds)

% calculate the mean and standard error of the Mean Square
% Displacements of particles
% 11/23/2015 Yao Zhao


% initialize and get dimension
numtracks=length(msds);
numlags=length(msds(1).t);
if isfield(msds(1),'z')
    dim=3;
else
    dim=2;
end
x=nan(numlags,numtracks);
y=nan(numlags,numtracks);
a=nan(numlags,numtracks);
if dim==3
    z=zeros(numlags,numtracks);
end

% merge
for itrack=1:numtracks
    x(:,itrack)=msds(itrack).x;
    y(:,itrack)=msds(itrack).y;
    if dim==3
        z(:,itrack)=msds(itrack).z;
    end
end

% combine mean
meanMSD.t=msds(1).t;
meanMSD.x=mean(x,2);
meanMSD.y=mean(y,2);
if dim==2
    meanMSD.sum=mean(x+y,2);
elseif dim==3
    meanMSD.z=mean(z,2);
    meanMSD.sum=mean(x+y+z,2);
end
% combine standard error
seMSD.t=msds(1).t;
seMSD.x=std(x,0,2)/sqrt(numtracks);
seMSD.y=std(y,0,2)/sqrt(numtracks);
if dim==2
    seMSD.sum=std(x+y,0,2)/sqrt(numtracks);
elseif dim==3
    seMSD.z=std(z,0,2)/sqrt(numtracks);
    seMSD.sum=std(x+y+z,0,2)/sqrt(numtracks);
end


end

