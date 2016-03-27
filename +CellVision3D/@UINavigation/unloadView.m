function unloadView(obj)
% unload a view
% 3/27/2016 Yao Zhao

% delete listener
delete(obj.listener_gonext);
% set handle to empty
delete(obj.uiview);
end