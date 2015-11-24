classdef DiffusionAnalysis < CellVision3D.HObject
    % class for diffusion analysis
    % 11/23/2015 Yao Zhao
    properties
        framerate % frame rate
        numlags % number of lags
    end
    
    methods 
        % get mean square displacements
        [msds]=getMSD(obj,particles);
    end
       methods (Static)
        % get mean msd
        [meanMSD,stdMSD]=getMSDStats(msds)
        
        % view the msd data
        viewMSD(msd,varargin)
        
        % get diffusion coefficient
        [ D,sigma2 ] = getDiffusionCoefficient(particles,varargin)
    end
    
end

