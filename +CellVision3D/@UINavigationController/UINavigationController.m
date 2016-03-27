classdef UINavigationController < CellVision3D.UINavigation
    % navigation function that controls ui switching
    % Yao Zhao 12/13/2015
    
    properties
        
%         % data
%         movie
%         cells
%         channelresults
    end
    
    methods
        % constructor
        function obj = UINavigationController()
            obj.uiviewclassnames={'CellVision3D.UIViewLoadMovie',...
                'CellVision3D.UIViewPreview',...
                'CellVision3D.UIViewCell',...
                'CellVision3D.UIViewRun',...
                'CellVision3D.UIViewAnalyze',...
                'CellVision3D.UIViewFinish'};
            obj.loadView(obj.uiviewclassnames{1});
        end
        
%         % override nextView to pass data, 
%         function nextView(obj,sourceObj,sourceData)
%             % call super method
%             [obj.movie,obj.cells]=nextView@CellVision3D.UINavigation(...
%                 obj,sourceObj,sourceData,obj.movie,obj.cells);
%         end
        
    end
    
end

