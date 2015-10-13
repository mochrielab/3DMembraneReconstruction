function [ D,sigma2 ] = getDiffusionCoefficient(X,varargin)

if nargin==1
    dt=1;
    dE=1;
elseif nargin==2
    dt=varargin{1};
    dE=dt;
elseif nargin==3
    dt=varargin{1};
    dE=varargin{2};
end
R = 1/6*dE/dt;
numTracks = length(X);
dim = size(X{1},2);
D = zeros(numTracks,dim);
sigma2 = zeros(numTracks,dim);
for i = 1:numTracks
    deltax = diff(X{i});
    cov1 = mean(deltax.^2);
    cov2 = mean(deltax(1:end-1,:).*deltax(2:end,:));
    D(i,:) = (cov1 + 2*cov2)/(2*dt);
    sigma2(i,:) = (cov1-2*D(i,:)*dt*(1-2*R))/2; 
end



end

