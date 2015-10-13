function [ h ] = SP( p0,varargin )
%plot patch image
% 3/12/2015 Yao Zhao

p1.vertices=p0.vertices;
p1.faces=p0.faces;

facecolor='r';
edgecolor='none';
facealpha='1';
edgealpha='1';

if nargin > 1
    if ~isempty(varargin{1})
        facecolor=varargin{1};
    end
end

if nargin > 2
    if ~isempty(varargin{2})
        edgecolor=varargin{2};
    end
end
if nargin  > 3
    if ~isempty(varargin{3})
        facealpha=varargin{3};
    end
end
if nargin  > 4
    if ~isempty(varargin{4})
        edgealpha=varargin{4};
    end
end

h=patch(p1,'FaceColor',facecolor,...
    'FaceAlpha',facealpha,'EdgeColor',edgecolor,...
    'EdgeAlpha',edgealpha);


view(3);
% camlight;
lighting gouraud;
axis image;

end

