
classdef ChannelBrightfieldContour3D < CellVision3D.Channel
    % channel for brightfield cell couturs in 3D
    % 11/17/2015 Yao Zhao
    
    properties
    end
    
    methods
        % constructor
        function obj=ChannelBrightfieldContour3D(label,type)
            obj@CellVision3D.Channel(label,type);
        end
        % generate cells from the a selected frame
        function contour=init(obj,varargin)
            iframe=1;
            if length(varargin)>=1
                iframe=varargin{1};
            end
            % get image
            img=obj.grabProjection(iframe);
            % get cell contours
            out=CellVision3D.guiselector.cellfinderbrightfield2Dgui( img );
            boundaries=out.boundaries;
            % save the data and generate cells
            contour=repmat(CellVision3D.Contour2D.empty,1,length(boundaries));
            for iframe=1:length(boundaries)
                contour(iframe)=CellVision3D.Contour2D(obj.label,1,boundaries{iframe});
            end
        end
    end
    
end

