classdef UIMessageBoard < CellVision3D.HObject
    % message board for message displacement
    
    properties
        % message field
        message_text
    end
    
    methods
        
        % constructor
        function obj=UIMessageBoard(message_panel)
            obj.message_text=uicontrol('Parent',message_panel,...
                'Style','listbox','BackgroundColor','w',...
                'String','','Units','normalized','Position',[0.02 0.02 .96 .96],...
                'FontSize',10);
        end
        
        % append text to the message board
        function appendMessage(obj,str)
            oldstr=get(obj.message_text,'String');
            set(obj.message_text,'String',[oldstr;{str}]);
        end
        
        % clear the message board
        function clearMessage(obj)
            set(obj.message_text,'String','');
        end
        
        % transfer command output to message board
        function outputMessageBoard(obj)
            % forward command window display to message board
            jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
            jCmdWin = jDesktop.getClient('Command Window');
            jTextArea = jCmdWin.getComponent(0).getViewport.getView;
            set(jTextArea,'CaretUpdateCallback',...
                @(hobj,eventdata)messageCallBack(hobj,eventdata,obj));
            function messageCallBack(hobj,eventdata,obj)
                text=char(hobj.getText);
                returns=regexp(text,'\n');
                text=text(returns(max(1,length(returns)-25))+1:end);
                set(obj.message_text,'String',text);
            end
        end
        
        
        % destructor
        function delete(obj)
            jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
            jCmdWin = jDesktop.getClient('Command Window');
            jTextArea = jCmdWin.getComponent(0).getViewport.getView;
            set(jTextArea,'CaretUpdateCallback',[])
        end
    end
    
end

