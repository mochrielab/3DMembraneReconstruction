classdef UIViewInit < CellVision3D.UIView
    % uiview initialize the movies
    % Yao Zhao 12/12/2015
    
    
    properties (Constant)
    end
    
    properties
        cell_methods_selector_handle
    end
    
    methods
        % constructor
        function obj=UIViewInit()
            obj@CellVision3D.UIView();
            channel_y0=0.9;
            channel_dy=0.06;
            margin=0.01;
            % cell constructor types
            uicontrol('Parent',obj.main_panel,...
                'Style','text',...
                'String','Please choose how to construct the cells from multiple channels',...
                'Units','normalized','Position',[margin channel_y0+margin-0.01 2/3-2*margin channel_dy-2*margin],...
                'FontSize',20,'HorizontalAlignment','left');
            [constructionmethods,descriptions]=CellVision3D.Cell.getCellConstructionMethods;
            obj.cell_methods_selector_handle=uicontrol('Parent',obj.main_panel,...
                'Style','popupmenu',...
                'String',descriptions,'value',1,...
                'Units','normalized','Position',[margin channel_y0-channel_dy+margin 2/3-2*margin channel_dy-2*margin],...
                'FontSize',20,'CallBack',@(hobj,eventdata)getFilters(hobj,eventdata,obj));

            %
            obj.printHelpMessage;
            
            % set channels
            function getFilters(hobj,eventdata,obj)
            end
            
        end
        
  
        
    end
    
end

