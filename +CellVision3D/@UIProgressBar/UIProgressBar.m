classdef UIProgressBar < handle
    % matlab ui progress bar
    % Yao Zhao 12/12/2015
    
    properties
        parent_handle
        size
        barcolor
        backgroundcolor
        axes_handle
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
            if isempty(obj.parent_handle)
                obj.parent_handle=...
                    figure('Position',obj.size,'Name','Progress',...
                    'NumberTitle','off','DockControls','off',...
                    'MenuBar','none','ToolBar','none');    
            end
            obj.axes_handle=axes('Parent',obj.parent_handle,...
                'Position',[0 0 1 1]);
            set(obj.axes_handle,'Unit','Pixels');
            obj.size=get(obj.axes_handle,'Position');
            set(obj.axes_handle,'Unit','Normalized');
            obj.setPercentage(0);
        end
        
        % show percentage
        function setPercentage(obj,percentage,varargin)
            cla(obj.axes_handle);
            axes(obj.axes_handle);
            set(obj.axes_handle,'Unit','Normalized','Position',[0 0 1 1]);
            rectangle('Position',[0 0 1 1],'FaceColor',obj.backgroundcolor);
            hold on;
            rectangle('Position',[0,0,percentage,1],...
                'FaceColor',obj.barcolor,'EdgeColor','none');
            if nargin>2
%                 text(obj.size(3)/2-length(varargin{1}),10,varargin{1});
                text(0.5,.5,varargin{1},'linewidth',2);
            end
            drawnow;
        end
        
    end
    
end

