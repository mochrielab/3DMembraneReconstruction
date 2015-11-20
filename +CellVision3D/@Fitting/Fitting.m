classdef Fitting < handle
    % a collection of fitting functions
    % Yao Zhao 11/19/2015
    properties
    end
    
    methods (Static)
        % n particle 3d gaussian no background
        [ fmin ,grad] = NGaussian3D0B( p,x,y,z,img3,sigdiff,zxr)
        % n particle 2d gaussian no background
        [ fmin ,grad] = NGaussian2D0B( p,x,y,img)
    end
    
end

