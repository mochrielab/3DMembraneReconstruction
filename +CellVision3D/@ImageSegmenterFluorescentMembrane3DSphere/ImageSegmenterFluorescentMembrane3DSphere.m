classdef ImageSegmenterFluorescentMembrane3DSphere < ...
        CellVision3D.ImageSegmenterFluorescentMembrane2D ...
        & CellVision3D.Object3D
    % the image segmentation for 3D fluorscent membrane, near spherical
    % shapes
    % Yao Zhao 12/4/2015
    
    properties 
    end
    
    methods 
        % segment a image
        function out=segment(obj,image3,varargin)
            import CellVision3D.*
            % segment projection image
            proj=squeeze(sum(image3,3));
            out=segment@CellVision3D...
                .ImageSegmenterFluorescentMembrane2D(obj,proj);
            numcells=length(out);
            % get a center estimation
            numstacks=size(image3,3);
            mI=zeros(numcells,numstacks);
            for istack=1:numstacks
                % gradient of the image in each stack
%                 im=imgradient(image3(:,:,istack));
                im=(image3(:,:,istack));
                for icell=1:numcells
                    pixlist=out(icell).PixelIdxList;
                    mI(icell,istack)=mean(im(pixlist));
%                     [iy,ix]=ind2sub(size(im),pixlist);
%                     wimg3=image3(min(iy):max(iy),min(ix):max(ix),:);
%                     wimg=wimg3(:,:,istack);
%                     wimg=wimg-mean(wimg3(:));
%                     wimg(wimg<0)=0;
%                     mx=(1+size(wimg,2))/2;
%                     my=(1+size(wimg,2))/2;
%                     [x,y]=meshgrid((1:size(wimg,2))-mx,(1:size(wimg,1))-my);
%                     mI(icell,istack)=sum(sum((x.^2+y.^2).*wimg))/sum(wimg(:));

                end
            end
            % gaussian fit to search for the center of each cell in the z
            % stack
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
                if obj.check(varargin,'showplot')
                    xtest=1:.1:numstacks;
                    [~,~,fval]=CellVision3D.Fitting.NGaussian1D0B(p,xtest,xtest);
                    plot((1:numstacks)',mI(icell,:)','or',xtest,fval,'-b');hold on;
                end
            end

        end
    end
    
end

