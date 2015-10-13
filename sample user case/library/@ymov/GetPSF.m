function [ obj ] = GetPSF( obj, varargin )
% get the point spread function information
% option to calculate or input a already calculated psf
% 3/23/2015
% Yao Zhao

if nargin==1
pm=psfmov;
[psfparam.sigdiff,psfparam.minsig,psfparam.ppsf]=pm.psfxzdiff();
elseif nargin==2
psfparam=varargin{1};
end
obj.psfparam=psfparam;

end

