classdef Particle < matlab.mixin.Heterogeneous & handle 
    % basic class for particle analysis
    % Yao Zhao 11/17/2015
    properties (SetAccess = protected)
        label     % label for the particle
        positions % positions matrix for the particles
        dimension % dimension
        sigmas    % width of the particles
        brightness% brightness of the particles
        numframes % number of frames
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
       % add data to frame
       function addFrame(obj,pos,iframe)
           dim=obj.dimension;
           obj.positions(iframe,1:dim)=pos(1:dim);
           obj.brightness(iframe,1)=pos(dim+1);
           numsigma=length(pos)-1-dim;
           obj.sigmas(iframe,1:numsigma)=pos(dim+2:end);
           obj.iframe=iframe;
           obj.tmppos=pos(1:dim+1);
       end
       % get centroid of the object
       % may pass in 1 variable to get centroid from that frame
       function cnt=getCentroid(obj,varargin)
           dim=obj(1).dimension;
           currentframe=obj.iframe;
           if nargin>=2
               currentframe=varargin{1};
           end
           
           cnt=zeros(length(obj),obj(1).dimension);
           for ip=1:length(obj)
               if currentframe==0
                   cnt(ip,:)=obj(ip).tmppos(1:dim);
               else
                   cnt(ip,:)=obj(ip).positions(currentframe,1:dim);
               end
           end
       end
    end
    
    %     methods (Abstract)
%     end
    
end

