classdef CellFilter < CellVision3D.HObject
    % filter for cells
    % rules for setting filter is
    % CellFilter(channellabel,filtertype,[minval,maxval]);
    % setFilter(channellabe,filtertype,[valuemin,valuemax],...);
    % 11/18/2015 Yao Zhao
    
    properties
        FluorescentParticle3D_number % filters for particles of different number
    end
    
    methods
        % constructer
        function obj=CellFilter(varargin)
            obj.setFilter(varargin{:});
        end
        
        % set parameter
        obj=setFilter(obj,varargin)
        
        % apply filter
        cells=applyFilter(obj,cells)
    end
    
end

