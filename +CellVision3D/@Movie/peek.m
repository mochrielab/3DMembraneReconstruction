function [  ] = peek( obj )
% peek in to the movie file and try finding values
% 3/31/2016

if ~exist(obj.filein,'file')
    warning('invalid movie data path');
    
    
else
    
    data=bfopenSelect(obj.filein,1);
    
    
    omeMeta1=data{4};
    try
        if isempty(obj.pix2um)
            obj.pix2um=omeMeta1.getPixelsPhysicalSizeY(0).getValue();
        else
            warning('pixel to micron ratio already set, skip reading metadata');
        end
    catch
        
        warning('no pixel to um information')
    end
    try
        if isempty(obj.vox2um)
            obj.vox2um=omeMeta1.getPixelsPhysicalSizeZ(0).getValue();
        else
            warning('voxel to micron ratio already set, skip reading metadata');
        end
    catch
        
        warning('no voxel to um information');
    end
    try
         if isempty(obj.sizeZ)
        obj.sizeX=omeMeta1.getPixelsSizeX(0).getValue();
        obj.sizeY=omeMeta1.getPixelsSizeY(0).getValue();
        obj.sizeZ=omeMeta1.getPixelsSizeZ(0).getValue();
        obj.numstacks=obj.sizeZ;
        obj.numframes=omeMeta1.getPixelsSizeT(0).getValue();
         else
             warning('spatial information already set, skip reading metadata');
         end
    catch
        warning('incomplete or no image size information');
    end
    
    
    
end