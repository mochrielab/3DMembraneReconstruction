classdef DriftControlBrightfield3D < CellVision3D.HObject
    % drift control class for movies
    % track the bead diffraction patterns in 3d to infer the drift
    % 11/19/2015 Yao Zhao
    
    properties
        windowsize % window size for the correlation
        correlationwindowsize=11 % size of correlation matrix
        maxdisp=5 % max display from the center of fitting
        
        centroid % center for the bead
        template % saved template for analysis
        
        positiondrift % drift coordinates
        
        dimension=3 % 3d
        numframes % number of frames
        
        lockthreshold =0.5
%         locksensitivity
%         lockzcenter
%         lockxcenter
%         lockycenter

     end
    
    methods
        % constructor
        function obj=DriftControlBrightfield3D(cnt,windowsize)
            obj.centroid=round(cnt);
            obj.windowsize=windowsize;
%             obj.numframes=numframes;
        end
        
        % generate template
        generateTemplate(obj, img3)
        
        % fit to template
        drift = getDrift(obj, img3)
        
    end
    methods 
        [param] = getCorrelation(obj, img,template)
        
        % get correlation to the template of a full stack
        function params = getCorrelations(obj,img3,template)
            numstacks=size(img3,3);
            params=zeros(numstacks,4);
            for i=1:numstacks
                params(i,:)=obj.getCorrelation(img3(:,:,i),template);
            end
        end
    end
end


