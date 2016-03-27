function loadView(obj,uiviewname,varargin)
% load a UI view
% 3/27/2016 Yao Zhao

% load view
if nargin==2
    eval(['obj.uiview=',uiviewname,'();']);
elseif nargin>=3
    eval(['obj.uiview=',uiviewname,'(varargin{1});']);
end
% add listner to go next
obj.listener_gonext = ...
    addlistener(obj.uiview,'goNext',@(hobj,data)obj.nextView(hobj,data));
end