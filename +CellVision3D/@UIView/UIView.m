classdef UIView < CellVision3D.HObject & matlab.mixin.Heterogeneous
    % base class for uiview
    % 12/12/2015 Yao Zhao
    properties
        % figure handle
        figure_handle
        screen_size
        % menubar handles
        menubar_file_handle
        menubar_file_new_handle
        menubar_file_save_handle
        menubar_file_load_handle
        menubar_file_exit_handle
        menubar_help_handle
        % progress bar handle
        progress_bar_handle
        % message board
        message_board_handle
        % panels
        main_panel
        message_panel
        navigation_panel
        progress_panel
        % navigation button
        navigation_next_button
        % data handle
        data
        % setter array handles
        setter_array_handles
    end
    
    methods
        % constructor
        function obj=UIView(varargin)
            % pass data
            if nargin>0
                obj.data=varargin{1};
            end
            % generate figure
            siz=get(0,'ScreenSize');
            obj.screen_size=[0 0+50 siz(3) siz(4)-50];
            obj.figure_handle=figure('OuterPosition',obj.screen_size,...
                'DeleteFcn',@(hobj,eventdata)obj.delete);
            % set figure properties
            set(obj.figure_handle,'Name',['CellVision3D : ',...
                'Reconstruct cell contours, fluorescent membrane ',...
                'and fluorescent particles. Merge reconstructed results. ',...
                'Statistics on results.']);
            set(obj.figure_handle,'NumberTitle','off');
            set(obj.figure_handle,'DockControls','off');
            set(obj.figure_handle,'MenuBar','none');
            set(obj.figure_handle,'ToolBar','none');
            % add menu bar
            % file session
            obj.menubar_file_handle=uimenu(obj.figure_handle,'Label','File');
            obj.menubar_file_new_handle=...
                uimenu(obj.menubar_file_handle,'Label','New');
            obj.menubar_file_save_handle=...
                uimenu(obj.menubar_file_handle,'Label','Save');
            obj.menubar_file_load_handle=...
                uimenu(obj.menubar_file_handle,'Label','Load');
            obj.menubar_file_exit_handle=...
                uimenu(obj.menubar_file_handle,'Label','Exit');
            % help session
            obj.menubar_help_handle=uimenu(obj.figure_handle,'Label','Help');
            % add progress bar
            obj.progress_panel = uipanel('Position',[0 0 1 1/50]);
            obj.progress_bar_handle = ...
                CellVision3D.UIProgressBar('parent_handle',obj.progress_panel);
            obj.progress_bar_handle.setPercentage(.0);
            % add panels
            % main
            obj.main_panel=uipanel('Position',[0 1/50 3/4 1-1/50]);
            % message
            obj.message_panel=uipanel('Position',[3/4 1/2 1/4 1/2],...
                'Title','Messages');
            obj.message_board_handle=CellVision3D...
                .UIMessageBoard(obj.message_panel);
            % navigation
            obj.navigation_panel=uipanel('Position',[3/4 1/50 1/4 1/2-1/50],...
                'Title','Navigations');
            obj.navigation_next_button=uicontrol('Parent',obj.navigation_panel,...
                'Style','pushbutton',...
                'String','Next','Units','normalized','Position',[.05 .05 .9 .2],...
                'FontSize',20,'CallBack',@(hobj,eventdata)notify(obj,'goNext'));
        end
        
        
        
        % clear panel
        function clearMainPanel(obj)
            ch=get(obj.main_panel,'Children');
            for i=1:length(ch)
                delete(ch(i));
            end
        end
        
        % function print to message board
        function print(obj,str)
            obj.message_board_handle.appendMessage(str);
        end
        % clear message board
        function clear(obj)
            obj.message_board_handle.clearMessage();
        end
        
        % delete
        function delete(obj)
            if ishandle(obj.figure_handle)
                close(obj.figure_handle);
            end
        end
        
        % create parameter setter array
        displaySetterArray(obj,obj_handles,obj_names,varargin)
        
        % clear parameter setter array
        function clearSetterArray(obj)
            try
                delete(obj.setter_array_handles);
                obj.setter_array_handles=[];
            catch
            end
        end
        
        % go next
        function next(obj)
        end
    end
    
    methods (Static)
        desc = getDescription(classname,propname);
    end
    
    events
        goNext
    end
    
end

