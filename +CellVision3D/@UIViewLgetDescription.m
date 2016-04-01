function [ desc ] = getDescription( classname, propname )
% get the description of parameters in UIVIEW
% 3/31/2016 Yao Zhao

desc=[];
switch classname
    case 'CellVision3D.Movie'
        switch propname
            case 'pix2um'
                desc='pixel size (microns)';
            case 'vox2um'
                desc='voxel size (microns)';
            case 'aberation'
                desc='aberation correction ratio';
            case 'numstacks'
                desc='number of stacks';
            case 'numframes'
                desc='number of frames';
            case 'sizeX'
                desc='width of image (pixels)';
            case 'sizeY'
                desc='height of image (pixels)';
            case 'sizeZ'
                desc='number of stacks';
        end
    case 'CellVision3D.ChannelFluorescentParticle3D'
        switch propname
            case 'bordercutz'
                desc='remove particle near axial border (pixels)';
            case 'lnoise'
                desc='gaussian filter smoothing strength (pixels)';
            case 'lobject'
                desc='size of the particles (pixels)';
            case 'peakthreshold'
                desc='minimum relative intensity for particle detection (0-1)';
            case 'bordercut'
                desc='remove particle near lateral border (pixels)';
            case 'mindist'
                desc='minimum distance between particles (pixels)';
            case 'minsigma'
                desc='minimum size of particles fitting (pixels)';
            case 'maxsigma'
                desc='maxinum size of particles fitting (pixels)';
            case 'minpeak'
                desc='minimum relative intensity for particle fitting(0-1)';
            case 'maxpeak'
                desc='maximum relative intensity for particle fitting(0-1)';
            case 'fitwindow'
                desc='size of the fitting window (pixels)';
        end
    case 'CellVision3D.ChannelFluorescentMembrane3DSpherical'
        switch propname
            case 'ndivision'
                desc='mesh number index (increase 1 increase number of triangles by 3 times)';
            case 'lobject'
                desc='size of the membrane contour (pixels)';
            case 'lnoise'
                desc='gaussian filter smoothing strength (pixels)';
            case 'ncycles'
                desc='number of cycles to search for best image segmentation (larger number output better result by take longer time)';
            case 'padsame'
                desc='pad the image stack with same border image if membrane contour is cut off (alternative is using background to pad)';
                
        end
    otherwise
end


%             case ''
%                 desc='';
end

