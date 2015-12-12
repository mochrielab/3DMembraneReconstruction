function addFrame(obj,iframe,varargin)
% add data to frame
% Yao Zhao 12/11/2015
obj.iframe=iframe;
if nargin>=3
    dim=obj.dimension;
    pos=varargin{1};
    obj.positions(iframe,1:dim)=pos(1:dim);
    obj.brightness(iframe,1)=pos(end);
    numsigma=length(pos)-1-dim;
    obj.sigmas(iframe,1:numsigma)=pos(dim+1:end-1);
    obj.tmppos=pos(1:dim+1);
end
if nargin>=4
    obj.resnorm=varargin{2};
end
end