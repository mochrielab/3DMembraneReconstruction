classdef ParticleTracker < CellVision3D.HObject 
    % base class for particle tracking
    % use for extracing particle position from given image
    
    properties
        lnoise=.5          %   scale of noise
        lobject=5         % scale of object
        peakthreshold=0.3 % peak finding threshold
        bordercut=20 % border removal 
        maxdisp=5 % max display
        minsigma=.1   % lower bound of sigma
        maxsigma=10   % upper bound of sigma
        minpeak=.1 % min brightness ratio
        maxpeak=2 % max brightness ratio
        fitwindow=41 % window size for fitting
    end
    
    methods
        % constructor
        function obj=ParticleTracker(varargin)
            n=floor(nargin/2);
            for i=1:n
                obj.(varargin{2*i-1})=varargin{2*i};
            end
        end

    end
    
    methods (Abstract)
        pos=getPositions(obj,img);
    end
    
end

