classdef Contour2D < CellVision3D.Contour
    % basic class for contour analysis
    % Yao Zhao 11/17/2015
    properties (SetAccess = protected)
%         label     % label for the particle
        boundaries % cell type of 
%         dimension % dimension
        numframes % number of frames
    end
    
    properties (SetAccess = protected)
%         iframe=0    % current frame
        tmpbb % temporary position vector
    end
    
    methods
        % constructor
        function obj=Contour2D(label,numframes,bb)
            obj@CellVision3D.Contour(label,numframes);
            obj.dimension=2;
            obj.boundaries=cell(obj.numframes,1);
            obj.tmpbb=bb;
        end

        % get bb
        function bb=getBoundaries(obj,varargin)
           currentframe=obj.iframe;
           if nargin>=2
               currentframe=varargin{1};
           end
           
           bb=cell(length(obj),1);
           for ip=1:length(obj)
               if currentframe==0
                   bb(ip)={obj(ip).tmpbb};
               else
                   bb(ip)=obj(ip).boundaries(currentframe);
               end
           end
        end
        
    end
    
    methods (Abstract)
        
    end
    
end
