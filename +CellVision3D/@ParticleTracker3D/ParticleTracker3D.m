classdef ParticleTracker3D < CellVision3D.ParticleTracker
    % 3d particle tracking
    % use for extracing particle position from given image
    
    properties
        zxr % zxr ratio
        bordercutz=2; % remove things near border
    end
    
    methods
        % constructor
        function obj=ParticleTracker3D(varargin)
            n=floor(nargin/2);
            for i=1:n
                obj.(varargin{2*i-1})=varargin{2*i};
            end
        end        
    end
    
    methods 
        % get particle peak positions
        pk=getPositions(obj,zstack,varargin)
        % fit particles to gaussian, fit particles to a image
        [param2,resnorm]=fitPositions(obj,img3,pcnt,varargin)
        
    end
    
    methods (Static)
        bimg=bpass3(img,lnoise,lobj,zxr)
        pks=pkfnd3(img,th,lobj)
%         [ fmin ,grad] = NGaussian3D2( p,x,y,z,img3,sigdiff,zxr)
        [  ] = plotParticleZstack( img,pk,p,th,zxr,showplot )
    end
    
end

