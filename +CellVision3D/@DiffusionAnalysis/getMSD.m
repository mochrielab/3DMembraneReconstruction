function [msd]=getMSD(obj,particles)
% get the mean square displacement of a particle arrays
% 11/23/2015 Yao Zhao

% initialize
t=(1:obj.numlags)'/obj.framerate;
msdtmp.t=t;
msdtmp.x=zeros(obj.numlags,1);
msdtmp.y=zeros(obj.numlags,1);
if particles(1).dimension==2
elseif particles(1).dimension==3
    msdtmp.z=zeros(obj.numlags,1);
end
numparticles=length(particles);
msd=repmat(msdtmp,numparticles,1);
numframes=particles(1).numframes;

% get averaged msd
for iparticle=1:numparticles
    pos=particles(iparticle).positions;
    for ilag=1:obj.numlags
        rho=zeros(numframes-ilag,particles(iparticle).dimension);
        for j=1:numframes-ilag
            rho(j,:)=(pos(j+ilag,:)-pos(j,:)).^2;
        end
        msd(iparticle).x(ilag)=mean(rho(:,1));
        msd(iparticle).y(ilag)=mean(rho(:,2));
        if particles(iparticle).dimension ==3
            msd(iparticle).z(ilag)=mean(rho(:,3))*particles(iparticle).zxr^2;
        end
    end
end

