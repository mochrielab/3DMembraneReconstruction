classdef PSF < CellVision3D.HObject
    % point spread function of the microscope
    % used to extract point spread function from image template
    % 11/20/2015 Yao Zhao
    
    properties
        dsigma % differences in the sigma between xy and z in the unit of pixels, not voxels
        sigmaxy % sigma xy
        sigmaz % sigma z, unit of pixels
    end
    
    methods
        % constructor
        function obj=PSF(sigmaxy,sigmaz)
            obj.sigmaxy=sigmaxy;
            obj.sigmaz=sigmaz;
        end
        % sigmadiff
        function dsigma=getDsigma(obj)
            dsigma=obj.sigmaz-obj.sigmaxy;
        end
    end
    
end

