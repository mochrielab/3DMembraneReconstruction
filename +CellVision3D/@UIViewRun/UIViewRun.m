classdef UIViewRun < CellVision3D.UIView
    % uiview run individual channels
    % Yao Zhao 12/12/2015
    
    
    properties (Constant)
    end
    
    properties
        cell_methods_selector_handle
    end
    
    methods
        % constructor
        function obj=UIViewRun(varargin)
            obj@CellVision3D.UIView(varargin{:});
            channel_y0=0.9;
            channel_dy=0.06;
            margin=0.01;
            % cell constructor types
            uicontrol('Parent',obj.main_panel,...
                'Style','text',...
                'String','Please click next to start analysis, will take time',...
                'Units','normalized','Position',[margin channel_y0+margin-0.01 2/3-2*margin channel_dy-2*margin],...
                'FontSize',20,'HorizontalAlignment','left');
            % show window
            ax=axes('Parent',obj.main_panel,'Position',[0 0 .9 .9]);
            % print helper message
            obj.printHelpMessage;
            
            % plot preview
            for ichannel=1:min(3,obj.data.movie.numchannels)
                img=obj.data.movie.getChannel(1).grabProjection(1);
                if ichannel==1
                    img3=zeros([size(img),3]);
                end
                img3(:,:,ichannel)=(img-min(img(:)))/(max(img(:))-min(img(:)));
            end
            
            if obj.data.movie.numchannels>1
                obj.data.cells.view(0,img3);
            else 
                obj.data.cells.view(0,img);
            end
        end
        
        
        
    end
    
end

