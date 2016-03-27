classdef UINavigation < CellVision3D.HObject
    % navigation function that controls ui switching
    % Yao Zhao 12/13/2015
    
    properties
        % views
        uiviewclassnames % array of unique class names
        uiview % current ui view
        % listeners
        listener_gonext
        % data handle
        data
    end
    
    methods
        % load viewer
        loadView(obj,uiviewname,varargin)
        % unload viewer
        unloadView(obj)
        % go to next viewer
        nextView(obj,sourceObj,sourceData)
        
    end
    
end

