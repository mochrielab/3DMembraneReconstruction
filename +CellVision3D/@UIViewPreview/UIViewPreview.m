classdef UIViewPreview < CellVision3D.UIView
    % uiview run individual channels
    % Yao Zhao 12/12/2015
    
    
    properties (Constant)
    end
    
    properties
    end
    
    methods
        % constructor
        function obj=UIViewPreview(varargin)
            obj@CellVision3D.UIView(varargin{:});
            obj.navigation_next_button.set('String','Preview Next Channel',...
                'Callback',@(hobj,eventdata)uiresume);
            obj.printHelpMessage;
            pause(0.001);
            % loop
            movie=obj.data.movie;
            numchannels=movie.numchannels;
            for i=1:numchannels
                %% set input parameters
                % update buttion text
                obj.navigation_next_button.set('String','Accept parameters for preview')
                pause(0.01);
                % set progress bar
                obj.progress_bar_handle.setPercentage(i/(numchannels),...
                    ['initiallizing ',movie.getChannel(i).type,...
                    ' channel: ',movie.getChannel(i).label]);
                
                % create parameter array
                obj.displaySetterArray({movie.getChannel(i)},[],{movie.getChannel(i).isNonChannelParam});
                
                % wait for next channel
                % wait for the figure to close by pressing next channel
                uiwait(obj.figure_handle)
                obj.clearSetterArray;
                %% initialize the channel for based on input parameters
                obj.navigation_next_button.set('String','Please Wait ...')
                pause(0.01);
                % initialize
                obj.data.channelresults{i}=movie.getChannel(i).init(1);
                % create view for display axes
                ax=axes('Parent',obj.main_panel,'Position',[0 0 1 1]);
                movie.getChannel(i).view();
                % set progress bar
                obj.progress_bar_handle.setPercentage(i/(numchannels),...
                    ['initiallizing ',movie.getChannel(i).type,...
                    ' channel: ',movie.getChannel(i).label]);
                % wait for next channel, skip last one
                if i<numchannels
                    obj.navigation_next_button.set('String','Preview Next Channel')
                    pause(0.01);
                    % wait for the figure to close by pressing next channel
                    uiwait(obj.figure_handle)
                end
                % delete ax after clicked next
                delete(ax);
            end
            %
            obj.navigation_next_button.set('String','Next',...
                'CallBack',@(hobj,eventdata)notify(obj,'goNext'));
        end
        
        % next
        function next(obj)
        end
    end
    
end

