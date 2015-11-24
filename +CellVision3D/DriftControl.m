classdef DriftControl < CellVision3D.HObject
    % base class for drift control
    % 11/23/2015 Yao Zhao
    properties
        numframes % number of frames
        dimension % dimension of the data
        positiondrift % drift coordinates
        
    end
    
    methods (Abstract)
        drift=getDrift(obj,input)
    end
    
    methods (Static)
        function view(drift)
            dim=size(drift,2);
            if dim==2
                plot(drift(:,1),drift(:,2));
                xlabel('x');ylabel('y');axis equal;
            elseif dim==3
                plot3(drift(:,1),drift(:,2),drift(:,3));
                xlabel('x');ylabel('y');axis equal;
                zlabel('z')
            end
        end
    end
    
end

