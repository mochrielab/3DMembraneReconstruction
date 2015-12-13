classdef UINavigation < CellVision3D.HObject
    % navigation function that controls ui switching
    % Yao Zhao 12/13/2015
    
    properties
        % views
%         viewloadmovie=CellVision3D.UIViewLoadMovie.empty;
%         viewinitialize
%         viewmerge
%         viewrun
%         viewanalysis
        uiviewclassnames
        uiview
        % listeners
        listener_gonext
    end
    
    methods
        
        % load a view
        function loadView(obj,uiviewname)
            % load view
            eval(['obj.uiview=',uiviewname,'();']);
            % add listner to go next
            obj.listener_gonext = ...
                addlistener(obj.uiview,'goNext',@(hobj,data)obj.nextView(hobj,data));
        end
        
        % unload a view
        function unloadView(obj)
            % delete listener
            delete(obj.listener_gonext);
            % set handle to empty
            meta=metaclass(obj.uiview);
            classname=meta.Name;
            delete(obj.uiview);
        end
        
        % go to the next View
        function nextView(obj,sourceObj,sourceData)
            % find ui name
            meta=metaclass(sourceObj);
            classname=meta.Name;
            % find next uiview
            id=find(strcmp(obj.uiviewclassnames,classname));
            obj.unloadView();
            if id<length(obj.uiviewclassnames)
                obj.loadView(obj.uiviewclassnames{id+1});
            end
        end
    end
    
end

