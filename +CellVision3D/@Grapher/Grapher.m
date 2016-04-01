classdef Grapher
    % make graphs for publications
    % 3/31/2016 Yao Zhao
    
    properties
    end
    
    methods (Static)
        plot3DThreePanel(cell,varargin)
        [  ] = format( varargin )
        save(filename)
        [  ] = plot3DZ( contour,varargin  )
        [  ] = plot2DContour( contour, channel, pix2um , varargin )
        
        
    end
    
end

