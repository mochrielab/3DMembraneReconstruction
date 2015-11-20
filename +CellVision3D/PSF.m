classdef PSF
    %point spread function of the microscope
    
    properties
        dsigma
        sigmaxy
        sigmaz
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

