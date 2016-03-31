classdef Image3D < CellVision3D.Image
    % image operations of 3 dimensional
    % 11/19/2015 Yao Zhao
    
    properties
    end
    
    methods
    end
    
    methods (Static)
        [  ] = view( wimg3,varargin ) % 3d viewer
%         [ wimg ] = crop( img,roi ) % crop
        [ mx ] = pkfnd( im,th,sz ) % find peak
        [ gconv ] = bpass(img,lnoise,lobject,zxr ) % bandpass filter
        
        im2 = imdilate( img, se, varargin )
        im2 = imerode( img, se, varargin )
        im2 = imopen( img, se, varargin )
        im2 = imclose( img, se, varargin )
        [ se ] = strel( type, varargin)
        
        
        % 3d canny edge filter
        [ bw3 ] = edgeCanny( img3,th)
        
        % edge filer in 3d for bw image3
        [ e ] = edge(bw3,varargin);
        
        % set border pixels to zero
        [ img3 ] = cleanBorder( img3, bordercut )
        
        % bin the image
        [ b ] = binning( img3, bin )
        
        % apply a gaussian filter
        [ gconv ] = applyFilterGaussian( img,lnoise)
        
    end
end

