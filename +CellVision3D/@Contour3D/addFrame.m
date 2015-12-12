function addFrame(obj,iframe,varargin)
% add frame to certain frame
% Yao Zhao 12/11/2015
obj.iframe=iframe;

if nargin>=3
    obj.vertices{iframe}=varargin{1};
    obj.tmpvertices=varargin{1};
end

if nargin>=4
    obj.faces{iframe}=varargin{2};
    obj.tmpfaces=varargin{2};
end

end

