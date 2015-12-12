classdef DriftControlParticles < CellVision3D.DriftControl
    % drift control class for particles
    % calculate the average position of the particles to get the drift
    % 11/19/2015 Yao Zhao
    
    properties

     end
    
    methods
        % constructor
        
        % fit to template
        function [drift,chooseind] = getDrift(obj, particles)
            % init
            obj.dimension=particles(1).dimension;
            obj.numframes=particles(1).numframes;
            numparticles=length(particles);
            x=zeros(obj.numframes,numparticles);
            y=zeros(obj.numframes,numparticles);
            if obj.dimension==3
            z=zeros(obj.numframes,numparticles);
            end
            
           % merge
           for ipar=1:numparticles
               x(:,ipar)=particles(ipar).positions(:,1);
               y(:,ipar)=particles(ipar).positions(:,2);
               if obj.dimension==3
                   z(:,ipar)=particles(ipar).positions(:,3);
               end
           end
           
           % get initial drift
           mx = mean(x,2);
           drift.x =mx-mx(1);
           my = mean(y,2);
           drift.y = my-my(1);
           if obj.dimension==3
               mz=mean(z,2);
               drift.z=[mz-mz(1)];
           end
           if obj.dimension==2
               drift=[drift.x,drift.y];
           elseif obj.dimension==3
               drift=[drift.x,drift.y,drift.z];
           end
           
           % calculate rms based on initial drift
           rms=zeros(numparticles,obj.dimension);
           for ipar=1:numparticles
               rms(ipar,:)=var(particles(ipar).positions - drift,0,1);
           end
           
           % exclude bad particles
           chooseind= sum(rms>ones(numparticles,1)*(mean(rms,1)+1*std(rms,0,1)),2)==0;
           
           % recalculate the drift in each axis
           drift=[];
           mx = mean(x(:,chooseind),2);
           drift.x =mx-mx(1);
           my = mean(y(:,chooseind),2);
           drift.y = my-my(1);
           if obj.dimension==3
               mz=mean(z(:,chooseind),2);
               drift.z=[mz-mz(1)];
           end
           
           % output
           if obj.dimension==2
               drift=[drift.x,drift.y];
           elseif obj.dimension==3
               drift=[drift.x,drift.y,drift.z];
           end
           
           
        end
    end

end


