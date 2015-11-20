classdef Image2D
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
        [  ] = view( wimg ) %  viewer
        [ wimg ] = crop( img,roi ) % crop
        [ mx ] = pkfnd( im,th,sz ) % find peak
        res = bpass(image_array,lnoise,lobject,threshold) % bandpass filter
        out=cntrd(im,mx,sz,interactive) % centroid finder
    end
end

