classdef ImageSegmenterFluorescentMembrane2D < CellVision3D.ImageSegmenter
    % The image segmeter class
    % used for image segmentation of fluorecent membrane type images
    % 11/20/2015 Yao zhao
    
    properties
        lobject=30 %length of the object
        lnoise=1  % scale of the noise
    end
    
    methods
        
        % segment a image
        function out=segment(obj,im)
            %%
            import CellVision3D.*
            lnoise=obj.lnoise;
            lobject=obj.lobject;
            % calcualte linear background
            im=Image2D.removeLinearBackground(im);
            % bandpass filter to remove background
            bimg=Image2D.bpass(im,lnoise,lobject);
            % do a optimization with canny edge filter parameter
            init=[.3,.9];
            lb=[.01, .05];
            ub=[.9, .95];
            options=optimoptions('fmincon','DiffMinChange',0.1,'Display','off');
            p=fmincon(@(th)foptim(th,bimg,lobject),init,[1 -1],[-0.01],[],[],lb,ub,[],options);
            % reconstruct the optimized image
            bw2=edge(bimg,'canny',[p(1),p(2)]);
            % clean up the image
            bw2=bwmorph(bw2,'close');
            bw2=imfill(bw2,'holes');
            % region properties filters
            ccs=regionprops(bw2,'area','Centroid','PixelIdxList','Perimeter','Eccentricity');
            cnt=[ccs.Centroid];
            cnt=[cnt(1:2:end)',cnt(2:2:end)'];
            area=[ccs.Area];
            areamax=pi*lobject^2/4*4;
            areamin=pi*lobject^2/4/4;
            eccentricity=[ccs.Eccentricity];
            prratio=[ccs.Perimeter]/2/pi./sqrt(area/pi);
            [~,index]=Image.removeNearBorder( cnt,im,lobject );
            ccs=ccs(area<areamax & area>areamin & index' & eccentricity<.6 ...
                & prratio < 3);
            out=ccs;
%             bw3=zeros(size(bw2));
%             for i=1:length(ccs)
%                 bw3(ccs(i).PixelIdxList)=1;
%             end
%             
            % function to be optimized
            function fmin=foptim(th,bimg,lobject)
                if(th(1)>th(2))
                    warning('wrong value, investigate');
                    th(1)=0.9*th(2);
                end
                e=edge(bimg,'canny',[th(1),th(2)]);
                e=bwmorph(e,'close');
                imf=imfill(e,'holes');
                cc=regionprops(imf,'area');
                a=[cc.Area];
                amax=pi*lobject^2/4*4;
                amin=pi*lobject^2/4/4;
                a=sum(a(a>amin&a<amax));
                l=sum(e(:));
                fmin = -a + l;
            end
        end
    end
    
end

