classdef Image3D
    % image operations of 3 dimensional
    % 11/19/2015 Yao Zhao
    
    properties
    end
    
    methods
%         % constructor 
%         function obj=Image3D(img);
%             obj.image=img;
%         end
    end
    
    methods (Static)
        [  ] = view( wimg3,varargin ) % 3d viewer
        [ wimg ] = crop( img,roi ) % crop
        [ mx ] = pkfnd( im,th,sz ) % find peak
        [ gconv ] = bpass(img,lnoise,lobject,zxr ) % bandpass filter
    end
end

