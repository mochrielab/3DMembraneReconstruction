classdef Geometry < CellVision3D.HObject
    % a collection of Math operations
    % 3/24/Yao Zhao
    
    properties
    end
    
    methods (Static)
        % get distance between two sets of coordinates
        [ distance ] = getDistance( v1, v2, varargin )
        % group a set of points based on some distance threshold
        [ groups ] = groupPoints( p, th, options, varargin )
        % get the cluster size of a set of points
        [ th ] = getPointsClusterSize( peaks,varargin )
    end
    
end

