classdef Image < CellVision3D.HObject
    % base class for image operations
    % contains general methods,
    % specific 2D and three 3D methods are described in each category
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
        [ wimg ] = crop( img,roi ); % crop
        [ th ] = getPercentageValue( img, percent );
        [ cnt2,index] = removeNearBorder( cnt,img,half_win )
    end
end

