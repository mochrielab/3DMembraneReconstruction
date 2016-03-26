classdef UIViewFinish < CellVision3D.UIView
    % uiview finish
    % pop a window to save the result
    % Yao Zhao 12/12/2015
    
    
    properties (Constant)
    end
    
    properties
        
    end
    
    methods
        % constructor
        function obj=UIViewFinish(varargin)
            obj@CellVision3D.UIView(varargin{:});
            % text
            channel_y0=0.9;
            channel_dy=0.06;
            margin=0.01;
            % cell constructor types
            uicontrol('Parent',obj.main_panel,...
                'Style','text',...
                'String','Analyze finished, please click save to finish',...
                'Units','normalized','Position',[margin channel_y0+margin-0.01 2/3-2*margin channel_dy-2*margin],...
                'FontSize',20,'HorizontalAlignment','left');
            obj.navigation_next_button.set('String','Save and Close');%,...
%                 'CallBack',@(hobj,eventdata)savefile(hobj,eventdata,obj));
            % print helper message
            obj.printHelpMessage;
            
            %
%             function savefile(hobj,eventdata,obj)
%                 % get filename
%                 try
%                     [FileName,PathName,FilterIndex] = ...
%                         uiputfile('*.mat','Please create a .mat file to save result',...
%                         obj.data.movie.filename);
%                 catch
%                     [FileName,PathName,FilterIndex] = ...
%                         uiputfile('*.mat','Please create a .mat file to save result',...
%                         'result');
%                 end
%                 % save file
%                 try
%                     obj.data.movie.save(1,fullfile(PathName,FileName));
%                     cells=obj.data.cells;
%                     save(fullfile(PathName,FileName),'cells','-append');
% %                     obj.unloadView();
%                 catch error
%                     msgbox(error.message);
%                 end
%             end

        end
        
        
    end
    
end

