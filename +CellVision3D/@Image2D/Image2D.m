classdef Image2D < CellVision3D.Image
    % image operations of 2 dimensional
    % this class contains 2D image operations
    % 11/19/2015 Yao Zhao
    
    properties
    end
    
    methods
    end
    
    methods (Static)
        [  ] = view( varargin ) %  viewer
%         [ wimg ] = crop( img,roi ) % crop
        [ mx ] = pkfnd( im,th,sz ) % find peak
        res = bpass(image_array,lnoise,lobject,threshold) % bandpass filter
        out=cntrd(im,mx,sz,interactive) % centroid finder
        [ im,bg,p ] = removeLinearBackground( im )
    end
end

