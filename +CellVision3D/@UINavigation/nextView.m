function nextView(obj,sourceObj,sourceData)
% go to the next View
% unload previous view and load new view
% 3/27/2016 Yao Zhao

try
    % call the next function from
    if strcmp(obj.uiview.navigation_next_button.get('String'),'Next')
        obj.uiview.navigation_next_button.set('String','Wait Pease...')
        obj.uiview.next();
        obj.data=obj.uiview.data;
        % find ui name
        meta=metaclass(sourceObj);
        classname=meta.Name;
        % find next uiview
        id=find(strcmp(obj.uiviewclassnames,classname));
        obj.unloadView();
        if id<length(obj.uiviewclassnames)
            obj.loadView(obj.uiviewclassnames{id+1},obj.data);
        end
    elseif strcmp(obj.uiview.navigation_next_button.get('String'),'Save and Close')
        obj.uiview.navigation_next_button.set('String','Wait Pease...')
        obj.uiview.next();
        obj.unloadView();
    end
catch error
    msgbox(error.message,'error');
    obj.uiview.navigation_next_button.set('String','Next');
end

end