classdef UIProgressBar < handle
    % matlab ui progress bar
    % Yao Zhao 12/12/2015
    
    properties
        axes_handle
        size
        barcolor
        backgroundcolor
    end
    
    methods
        % constructor
        function obj=UIProgressBar(varargin)
            % input: positions (optional)
            %        axes_handle (optional)
            
            % set values
            n=floor(length(varargin)/2);
            for i=1:n
                obj.(varargin{2*i-1})=varargin{2*i};
            end
            % default size
            if isempty(obj.size)
                obj.size=[100 100 800 100];
            end
            % default color
            if isempty(obj.backgroundcolor)
                obj.backgroundcolor='w';
            end
            % default color
            if isempty(obj.barcolor)
                obj.barcolor='r';
            end
            % default image
            if isempty(obj.axes_handle)
                figure('Position',obj.size,'Name','Progress',...
                    'NumberTitle','off','DockControls','off',...
                    'MenuBar','none','ToolBar','none');
                obj.axes_handle=axes('Position',[0 0 1 1]);
            end
            obj.setPercentage(0);
        end
        
        % show percentage
        function setPercentage(obj,percentage)
            cla(obj.axes_handle);
            rectangle('Position',[0 0 1 1],'FaceColor',obj.backgroundcolor);
            hold on;
            rectangle('Position',[0,0,percentage,1],...
                'FaceColor',obj.barcolor,'EdgeColor','none');
        end
        
    end
    
end

