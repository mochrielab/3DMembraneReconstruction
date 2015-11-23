classdef ImageSegmenterFluorecentMembrane3DSphere < ...
        CellVision3D.ImageSegmenterFluorecentMembrane2D
    % the image segmentation for 3D fluorscent membrane, near spherical
    % shapes
    
    properties
    end
    
    methods 
        % segment a image
        function out=segment(obj,image3)
            import CellVision3D.*
            % segment projection image
            proj=squeeze(sum(image3,3));
            out=segment@CellVision3D.ImageSegmenterFluorecentMembrane2D(obj,proj);
            numcells=length(out);
            % get a center estimation
            numstacks=size(image3,3);
            mI=zeros(numcells,numstacks);
            for istack=1:numstacks
                % gradient of the image in each stack
                im=imgradient(image3(:,:,istack));
                for icell=1:numcells
                    mI(icell,istack)=mean(im(out(icell).PixelIdxList));
                end
            end
            % gaussian fit to search for the center of each cell
            for icell=1:numcells
                [maxI,maxind]=max(mI(icell,:));
                init=[maxind,1,maxI];
                lb=[1,0.1,maxI*0.5];
                ub=[numstacks,numstacks,maxI*1.5];
                options=optimoptions('fmincon','Display','off');
                p=fmincon(@(p)CellVision3D.Fitting.NGaussian1D0B...
                    (p,1:numstacks,mI(icell,:)),init,[],[],[],[],...
                    lb,ub,[],options);
                out(icell).Centroid=[out(icell).Centroid,p(1)];
%                 xtest=1:.1:numstacks;
%                 [~,~,fval]=CellVision3D.Fitting.NGaussian1D0B(p,xtest,xtest);
%                 plot((1:numstacks)',mI(icell,:)','or',xtest,fval,'-b');hold on;
            end

        end
    end
    
end

