classdef Particle < CellVision3D.HObject & CellVision3D.UserData
    % basic class for particle analysis
    % data structure:
    % label, positions(numframes x dimension), dimensions,
    % sigmas(numframes x dimension-1), brightness(numframes x 1), 
    % numframes, resnorm (numframes x 1)
        
    
    
    % Yao Zhao 11/17/2015
    properties (SetAccess = protected)
        label     % label for the particle
        positions % positions matrix for the particles
        dimension % dimension
        sigmas    % width of the particles
        brightness% brightness of the particles
        numframes % number of frames
        resnorm   % fitting of the particle
        pix2um=1 % pixel to micron conversion
    end
    
    properties (SetAccess = protected)
        iframe=0    % current frame
        tmppos % temporary position vector
    end
    
    methods
        % constructor
        function obj=Particle(label,dimension,numframes)
            obj.label=label;
            obj.dimension=dimension;
            obj.numframes=numframes;
            obj.positions=nan(numframes,dimension);
            obj.sigmas=nan(numframes,dimension-1);
            obj.brightness=nan(numframes,1);
        end
        
        % add frame
        addFrame(obj,iframe,varargin)
        
        % get centroid
        cnt=getCentroid(obj,varargin)
        
        % remove drift
        function particles=removeDrift(particles,drift)
            for i=1:length(particles)
                particles(i).positions=particles(i).positions-drift;
                
            end
        end
        
        function setPix2um (obj,pixel2um)
            obj.pix2um = pixel2um;
        end
    end
    
    %     methods (Abstract)
    %     end
    
end

