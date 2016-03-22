classdef UIPopupQuestion < CellVision3D.HObject
    % this is a class for popup questions 
    % takes in 1 parameter, the question string
    % Yao Zhao 3/20/2016
    
    properties (Access=private)
        figure_handle % figure handle
        question % question string
        answer=0 % answer string
    end
    
    methods
        
        % constructor
        function obj=UIPopupQuestion(varargin)
            % if no question string is given
            if nargin == 0
                obj.question = 'Please give an answer';
            else
                obj.question = varargin{1};
            end
            
            % create a new figure
            siz=get(0,'ScreenSize');
            screen_size = [siz(3)/2-200 siz(4)/2-100, 400, 200];
            obj.figure_handle=figure('OuterPosition',screen_size);
            set(obj.figure_handle,'Name','','NumberTitle','off',...
                'DockControls','off','MenuBar','none','ToolBar','none')
            
            % create a question field
            uicontrol('Parent',obj.figure_handle,...
                'Style','Text',...
                'String',obj.question,...
                'Units','normalized','Position',[.05 .55 .9 .4],...
                'FontSize',12);
            %,'CallBack',@(hobj,eventdata)notify(obj,'goNext'));

            % create an anser field
            answer_string = uicontrol('Parent',obj.figure_handle,...
                'Style','Edit',...
                'Units','normalized','Position',[.2 .275 .6 .2],...
                'FontSize',20,...
                'CallBack',@(hobj,evendata)answerDidSet(hobj,evendata));
            function answerDidSet(hobj,evendata)
                obj.answer=hobj.get('String');
            end

            % create a continue button
            uicontrol('Parent',obj.figure_handle,...
                'Style','Pushbutton',...
                'String','Continue',...
                'Units','normalized','Position',[.05 .025 .9 .2],...
                'FontSize',20,...
                'CallBack',@(hobj,evendata)close(obj.figure_handle));

        end
        
        % return the answer to the question
        function answer = getAnswer(obj)
            answer=obj.answer;
        end
        
        % return figure handle
        function figurehandle = getFigureHandle(obj)
            figurehandle = obj.figure_handle;
        end
    end
    
end

