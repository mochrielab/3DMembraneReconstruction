classdef psfmov < dvmov
    %PSF is a class of poinst spread function calibration
    
    properties
        sigdiff
        minsig
        ppsf
    end
    
    methods
        function obj=psfmov()
            global codepath;
%             pathtmp=fullfile(userpath);
%             pathtmp=pathtmp(1:end-1); 
            obj=obj@dvmov(fullfile(codepath,'\library\@psfmov\PSF_02_R3D.dv'));
        end
        
        function [sigdiff,minsig,ppsf]=psfxzdiff(psfobj)
            psfobj.loadmovie;
            psfimg=[];
            for i=1:psfobj.numstacks
                psfimg(:,:,i)=psfobj.grab(1,i);
            end
            psfimg=psfimg-min(psfimg(:));
            zxr=psfobj.zxr;
            
            bpsfimg=bpass3(psfimg,0,5,zxr);
%             bpsfimg=psfimg;
            
            bpsfimg1=bpsfimg(:,:,60:70);
            th=0.5*max(bpsfimg1(:));
            psfpk=pkfnd3(bpsfimg1,th,[3,3]);
            psfpk(:,3)=psfpk(:,3)+59;
            [ny,nx,nz]=size(psfimg);
            ppsf=[];
            for i=1:size(psfpk,1)
                cx=round(psfpk(i,1));
                cy=round(psfpk(i,2));
                cz=round(psfpk(i,3));
                if cx>10 && cy>10 && cz>10 && cx<nx-10 &&cy<ny-10 && cz<nz-10
                    wpsfimg=bpsfimg(cy-10:cy+10,cx-10:cx+10,cz-10:cz+10);
                    [psfX,psfY,psfZ]=meshgrid(1:size(wpsfimg,2),1:size(wpsfimg,1),1:size(wpsfimg,3));
                    options = optimset('Algorithm','trust-region-reflective','TolX',1e-3,...
                        'Display','Off','MaxIter',1e4);
                    ini=[11,11,11,1,1,psfpk(i,4)];
                    lb=[10,10,10,0,0,psfpk(i,4)*.0];
                    ub=[12,12,12,8,15,psfpk(i,4)*20];
                    %                 ini=[11,11,11,1,1,psfimg(cy,cx,cz)];
                    %                 lb=[10,10,10,0,0,psfimg(cy,cx,cz)*.5];
                    %                 ub=[12,12,12,3,5,psfimg(cy,cx,cz)*2];
                    gauss3=@(p) exp(-((psfX-p(1)).^2+(psfY-p(2)).^2)/p(4)^2-(psfZ-p(3)).^2*zxr^2/p(5)^2)*p(6)-wpsfimg;
                    [p,resnorm,~,exitflag,~,~,~] = lsqnonlin(gauss3,ini,lb,ub,options);%,psfX,psfY,psfZ,wpsfimg);
                    p(1)=p(1)-11+cx;
                    p(2)=p(2)-11+cy;
                    p(3)=p(3)-11+cz;
                    ppsf=[ppsf;p];
                end
            end
%             ppsf(:,5)=ppsf(:,5)/psfobj.pix*psfobj.vox;
            s1=ppsf(:,4);
            s2=ppsf(:,5);
            linfit=@(p) s2-s1-p;
            sigdiff=lsqnonlin(linfit,0);
            
            % plot
%             plot(s1,s2,'bo',s1,s1+sigdiff,'r');
%             axis([0 max(s1)+1 0 max(s2)+1])
%             xlabel('\sigma_{xy}')
%             ylabel('\sigma_{z}')

%             for i=60:70%1:size(bpsfimg,3)
%                 clf
%                 subplot(1,2,1)
%                 img=psfimg;
%                 imagesc(squeeze(img(:,:,i)),[min(img(:)),max(img(:))]);axis image;colormap gray;
%                 subplot(1,2,2)
%                 img=bpsfimg;
%                 pksec=ppsf(round(ppsf(:,3))==i,[1,2]);
%                 imagesc(squeeze(img(:,:,i)),[min(img(:)),max(img(:))]);axis image;colormap gray;
%                 hold on;
%                 plot(pksec(:,1),pksec(:,2),'.b');
%                 pause
%             end
            minsig=min(s1);
            psfobj.sigdiff=sigdiff;
            psfobj.minsig=minsig;
            psfobj.ppsf=ppsf;
        end
    end
end

