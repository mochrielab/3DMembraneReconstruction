function [  ] = ResizeFont( handle,fontsize )
%resize all font size for the handle

set(findall(handle,'type','text'),'fontSize',fontsize,'fontWeight','bold')
set(findall(handle,'type','axes'),'fontSize',fontsize,'fontWeight','bold')

end

