classdef UINavigation < CellVision3D.HObject
    % navigation function that controls ui switching
    % Yao Zhao 12/13/2015
    
    properties
        % views
        uiviewclassnames % array of unique class names
        uiview % current ui view
        % listeners
        listener_gonext
    end
    
    methods
        
        % load a view
        function loadView(obj,uiviewname,varargin)
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
        
        % unload a view
        function unloadView(obj)
            % delete listener
            delete(obj.listener_gonext);
            % set handle to empty
            delete(obj.uiview);
        end
        
        % go to the next View
        function nextView(obj,sourceObj,sourceData)
            try
                % call the next function from
                if strcmp(obj.uiview.navigation_next_button.get('String'),'Next')
                    obj.uiview.navigation_next_button.set('String','Wait Pease...')
                    obj.uiview.next();
                    data=obj.uiview.data;
                    % find ui name
                    meta=metaclass(sourceObj);
                    classname=meta.Name;
                    % find next uiview
                    id=find(strcmp(obj.uiviewclassnames,classname));
                    obj.unloadView();
                    if id<length(obj.uiviewclassnames)
                        obj.loadView(obj.uiviewclassnames{id+1},data);
                    end
                end
            catch error
                msgbox(error.message,'error');
                obj.uiview.navigation_next_button.set('String','Next');
            end
        end
    end
    
end

