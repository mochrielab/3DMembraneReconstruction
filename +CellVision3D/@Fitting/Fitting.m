classdef Fitting < CellVision3D.HObject
    % a collection of fitting functions
    % Yao Zhao 11/19/2015
    properties
    end
    
    methods (Static)
        % n peak 3d gaussian no background
        [ fmin ,grad] = NGaussian3D0B( p,x,y,z,img3,sigdiff,zxr)
        % n peak 2d gaussian no background
        [ fmin ,grad] = NGaussian2D0B( p,x,y,img)
        % n peak 1d gaussian no background 
        [ fmin, grad, fval ] = NGaussian1D0B( p, xarray, yarray )
        % n peak 3d gaussian no background 2 sigma 
         [ fmin ,grad] = NGaussian3D0B2S( p,x,y,z,img3,zxr)
    end
    
end

