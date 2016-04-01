function [  ] = format( varargin )
%format the figure
switch nargin
    case 0
        handle=gcf;
        fontsize=14;
    case 1
        handle=varargin{1};
        fontsize=14;
    case 2
        handle=varargin{1};
        fontsize=varargin{2};
end
box off;
set(findall(handle,'type','text'),'fontSize',fontsize,'fontWeight','bold')
set(findall(handle,'type','axes'),'fontSize',fontsize,'fontWeight','bold')
set(findall(handle,'type','axes'),'Color','none', 'LineWidth',2);
set(findall(handle,'type','line'),'LineWidth',2);
end

