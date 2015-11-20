classdef ImageSegmenterFluorecentMembrane2D < CellVision3D.ImageSegmenter
    % The image segmeter class
    % used for image segmentation of fluorecent membrane type images
    % 11/20/2015 Yao zhao
    
    properties
        lobject=30 %length of the object
        lnoise=1  % scale of the noise
    end
    
    methods
        %         % constructor
        %         function ImageSegmenterFluorecentMembrane2D
        %         end
        
        
        % segment a image
        function out=segment(obj,image)
            %%
            import CellVision3D.*
            %             close all;
            lnoise=obj.lnoise;
            lobject=obj.lobject;
            im=image;
            im=Image2D.removeLinearBackground(im);
            bimg=Image2D.bpass(im,lnoise,lobject);
            init=[.3,.9];
            lb=[.01, .05];
            ub=[.9, .95];
            options=optimoptions('fmincon','DiffMinChange',0.1);
            p=fmincon(@(th)foptim(th,bimg,lobject),init,[1 -1],[-0.01],[],[],lb,ub,[],options)
            bw2=edge(bimg,'canny',[p(1),p(2)]);
            bw2=bwmorph(bw2,'close');
            bw2=imfill(bw2,'holes');
            cc=regionprops(bw2,'area','Centroid','PixelIdxList');
            cnt=[cc.Centroid];
            cnt=[cnt(1:2:end)',cnt(2:2:end)'];
            a=[cc.Area];
            amax=pi*lobject^2/4*4;
            amin=pi*lobject^2/4/4;
            [~,index]=Image.removeNearBorder( cnt,im,lobject );
            cc=cc(a<amax&a>amin&index');
            bw3=zeros(size(bw2));
            for i=1:length(cc)
                bw3(cc(i).PixelIdxList)=1;
            end
            Image2D.view(im,bw3);
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
            out=cc;
        end
    end
    
end

