classdef UINavigationController < CellVision3D.UINavigation
    % navigation function that controls ui switching
    % Yao Zhao 12/13/2015
    
    properties
        
        % data
        movie
        cells
    end
    
    methods
        % constructor
        function obj = UINavigationController()
            obj.uiviewclassnames={'CellVision3D.UIViewLoadMovie'};
            obj.loadView(obj.uiviewclassnames{1});
        end
    end
    
end

