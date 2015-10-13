function [  ] = FigureFormat( handle )
%format the figure
box off;
set(findall(handle,'type','text'),'fontSize',14,'fontWeight','bold')
set(findall(handle,'type','axes'),'fontSize',14,'fontWeight','bold')
set(findall(handle,'type','axes'),'Color','none', 'LineWidth',2);
set(findall(handle,'type','line'),'LineWidth',2);
end

