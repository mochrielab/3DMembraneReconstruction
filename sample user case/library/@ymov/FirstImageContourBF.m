function [ obj ] = FirstImageContourBF( obj,tag,id )
% process the first image
% extract cell contour information from bright field image
% tag decides which kind to use, movie or picture
% id is the id of movie or picture
% 3/22/2015
% Yao Zhao

if strcmp(tag,'picture');
    first_image_3d=obj.pictures{id};
    first_image=squeeze(sum(first_image_3d,3));
    
elseif strcmp(tag,'movie')
    if isa(id,'char')
        id=find(strcmp(id,obj.channelnames));
    elseif isa(id,'numeric')
    else
        error('unsupported channelname type');
        return
    end
    first_image_3d=obj.GrabImage3D(id,1);
    first_image=obj.GrabProjection(id,1);
    
else
    error('tag type not supported');
    return
end

if isempty(obj.cellcontour_ff)
    obj.cellcontour_ff=CellFinderBF(first_image);
else
    obj.cellcontour_ff=CellFinderBF(first_image,obj.cellcontour_ff.thmax,...
        obj.cellcontour_ff.thmin);
end

obj.cellcontour_ff.focalplane=GetFocusPlaneBF(first_image_3d);
obj.cellcontour_ff.type='contour';

end

