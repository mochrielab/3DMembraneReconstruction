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
        
        % get positions from a single frame
        function pk=getPositions(obj,zstack,varargin)
            bimg=CellVision3D.Image3D.bpass(zstack,obj.lnoise,...
                obj.lobject,obj.zxr);
            bimg=bimg/max(bimg(:));
            pk=CellVision3D.Image3D.pkfnd(bimg,obj.peakthreshold,...
                obj.lobject);
            bordercut=obj.bordercut;
            pk=pk(pk(:,1)>bordercut(1) & pk(:,1)<size(zstack,2)-bordercut(1) & ...
                pk(:,2)>bordercut(1) & pk(:,2)<size(zstack,1)-bordercut(1) & ...
                pk(:,3)>obj.bordercutz(1) & pk(:,3)<size(zstack,3)-obj.bordercutz(1),:);
            pk(:,4)=zstack(sub2ind(size(zstack),round(pk(:,1)),round(pk(:,2)),round(pk(:,3))));
            % decide if show plot
            for i=1:nargin-2
                if strcmp(varargin{i},'showplot')
                    proj=squeeze(sum(bimg,3));
                    imagesc(proj);colormap gray;hold on;
                    plot(pk(:,1),pk(:,2),'or');
                end
            end     
        end
        
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

