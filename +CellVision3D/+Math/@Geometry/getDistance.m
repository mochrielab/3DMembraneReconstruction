function [ distance ] = getDistance( v1, v2, varargin )
% get distance from two sets of coordinates
% support both 2d and 3d, optional input zxr for 3d
% for 2d, v1, v2 =[n x 2]
% for 3d, v1, v2 = [n x 3]
% 3/24/2015 Yao Zhao

% set the z to x ratio
if nargin == 2
    zxr=1;
elseif nargin == 3
    zxr = varargin{1};
else
    error('unsupported number of input: getDistance');
end

% check input size
if length(size(v1)) ~= length(size(v2))
    error('size of input doesnt match');
end
if sum((size(v1)-size(v2)).^2)
    error('size of input doesnt match');
end


% decide the dimension
dim = size(v1,2);
if dim ==2
    distance=sqrt((v1(:,1)-v2(:,1)).^2+(v1(:,2)-v2(:,2)).^2);
elseif dim ==3
    distance=sqrt((v1(:,1)-v2(:,1)).^2+(v1(:,2)-v2(:,2)).^2+(v1(:,3)-v2(:,3)).^2*zxr^2);
else
    error(['unsupported number of data dimension ',num2str(dim),': getDistance']);
end


end

