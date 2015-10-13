function np=process_singleframe_particle(np,iframe)
%% process a single frame to get particle position

%%
psfparam=np.psfparam;
%3d image
img3=np.grab3p(iframe);
%cnt guess 
% cnt=round(np.pcnt); %using center of nuclei
ncnt=zeros(np.num_nuc,3);
for inuc=1:np.num_nuc  % use nuclei center as the center
    ncnt(inuc,:)=round(np.nuclei{iframe,inuc}.origin);
end

% z stack contraints
zcut=2;
%window size
% hs=(np.wsize-1)/2;
hs2=17;
hs=hs2-zcut;
% aberation corrected z x ratio
zxr=np.vox/np.pix*np.aberation;
% max displacement from guessed position
maxdisp=4;
%%
np.particle=cell(np.numframes,np.num_nuc);
for inuc=1:np.num_nuc
    %% prepare image
    % get window image
    wimg3=img3(ncnt(inuc,2)+(-hs2:hs2),ncnt(inuc,1)+(-hs2:hs2),:);
    %use same 3d band pass filter as psf fitting, .5,zcut=2
    bimg3=bpass3(wimg3,.1,5,zxr);
    bimg3=bimg3./max(bimg3(:));
    bimg3=bimg3(hs2+1+(-hs:hs),hs2+1+(-hs:hs),1+zcut:end-zcut);
    %% fit to result
    % fit parameters
    [~,maxind]=max(bimg3(:));
    [yi,xi,zi]=ind2sub(size(bimg3),maxind);
    ini=[xi,yi,zi,1.25,1];
%     ini=[hs+1+cnt(inuc,1)-ncnt(inuc,1),hs+1+cnt(inuc,2)-ncnt(inuc,2),cnt(inuc,3)-zcut,1,1];
%     lb=[max(1,hs+1-maxdisp),max(1,hs+1-maxdisp),max(1,cnt(inuc,3)-zcut-maxdisp/zxr),.5,1.5,.1];
%     ub=[min(hs+1+maxdisp,2*hs+1),min(hs+1+maxdisp,2*hs+1),min(cnt(inuc,3)-zcut+maxdisp/zxr,size(bimg3,3)),4,6,2];
    lb=[1,1,1,.5,.3];
    ub=[1+2*hs,1+2*hs,size(bimg3,3),2,1.2];
%     options = optimset('Algorithm','trust-region-reflective','TolX',1e-3,...
%     'MaxIter',1e4,'TolFun',1e-8,'Display','off');
    [X,Y,Z]=meshgrid(1:size(bimg3,2),1:size(bimg3,1),1:size(bimg3,3));
    % single peak fitting
%     gaussn=@(p,Xs,Ys,Zs,I) NGaussian3D2(p,Xs,Ys,Zs,psfparam.sigdiff,zxr)-I;
%     [param1,resnorm,~,exitflag1,~,~,~] =
%     lsqnonlin(gaussn,ini,lb,ub,options,X,Y,Z,bimg3); changed 6/2
    fmin=@(p) NGaussian3D2(p,X,Y,Z,bimg3,psfparam.sigdiff,zxr);
%     [param1,resnorm,~,exitflag1,~,~,~] =
%     lsqnonlin(gaussn,ini,lb,ub,options);]
tic
    options1 = optimoptions('fmincon','Display','off','GradObj','on');
    [param1,fval1,~] = fmincon(fmin,ini,[],[],[],[],lb,ub,[],options1);  
%     resnorm1=sqrt(resnorm/numel(bimg3));
    resnorm1=sqrt(fval1/numel(bimg3));

    % double peak fitting
    ini2=[ini-.1;ini+.1];   
    lb2=[lb;lb];
    ub2=[ub;ub];
%     fmin=@(p)sum(sum(sum((NGaussian3D2(p,X,Y,Z,psfparam.sigdiff,zxr)-bimg3).^2)))/numel(bimg3);%...
%         +exp(-((p(1,1)-p(2,1))^2+(p(1,2)-p(2,2))^2+((p(1,3)-p(2,3))/zxr)^2)/0.01);
    options2 = optimoptions('fmincon','Display','off','GradObj','on');
    [param2,fval2,exitflag1] = fmincon(fmin,ini2,[],[],[],[],lb2,ub2,[],options2);
%     resnorm2=sqrt(sum(sum(sum((NGaussian3D2(param2,X,Y,Z,psfparam.sigdiff,zxr)-bimg3).^2)))/numel(bimg3));
    resnorm2=sqrt(fval2/numel(bimg3));

    %% differentiate single from double
    dist_2p=sqrt((param2(1,1)-param2(2,1))^2+(param2(1,2)-param2(2,2))^2+((param2(1,3)-param2(2,3))*zxr)^2);
%     resnorm2
%     resnorm1
    brightnessratio=min(param2(:,5))/max(param2(:,5));
% %     if resnorm2<resnorm1 && param2(1,5)>0.4 && param2(2,5)>0.4 && dist_2p>=0 && dist_2p<5
    if resnorm2<resnorm1 && brightnessratio>0.4 && dist_2p>=0.0 && dist_2p<5
        isdouble=1;
    else
        isdouble=0;
    end
    %% calculate fitness
    if isdouble
        pcnt=round(mean(param2,1));
    else
        pcnt=round(param1);
    end
    shw=4;
    sx=max(1,pcnt(1)-shw):min(2*hs+1,pcnt(1)+shw);
    sy=max(1,pcnt(2)-shw):min(2*hs+1,pcnt(2)+shw);
    sz=max(1,pcnt(3)-shw):min(size(bimg3,3),pcnt(3)+shw);
    [sX,sY,sZ]=meshgrid(sx,sy,sz);
    sbimg3=bimg3(sy,sx,sz);
%     sresnorm1=sqrt(sum(sum(sum((gaussn(param1,sX,sY,sZ,sbimg3)).^2)))/numel(sbimg3));
%     sresnorm2=sqrt(sum(sum(sum((gaussn(param2,sX,sY,sZ,sbimg3)).^2)))/numel(sbimg3));
    sresnorm1=sqrt(NGaussian3D2(param1,sX,sY,sZ,sbimg3,psfparam.sigdiff,zxr)/numel(sbimg3));
    sresnorm2=sqrt(NGaussian3D2(param2,sX,sY,sZ,sbimg3,psfparam.sigdiff,zxr)/numel(sbimg3));
%     small_hw=4;
%     pcnt(1:2)=pcnt(1:2)-hs-1+ncnt(inuc,1:2);
%     swimg3=img3(pcnt(inuc,2)+(-small_hw:small_hw),pcnt(inuc,1)+(-small_hw:small_hw),:);
        %% plot
    if 0
    isdouble
        wimg3tmp=img3(ncnt(inuc,2)+(-hs:hs),ncnt(inuc,1)+(-hs:hs),1+zcut:end-zcut);
    if isdouble==0
        ShowImgTrk3(wimg3tmp,param1(1:3),param1,.3,zxr,.1);
    else
        ShowImgTrk3(wimg3tmp,param2(1:3),param2,.3,zxr,.1);
    end
    if isdouble==0
        ShowImgTrk3(bimg3,param1(1:3),param1,.3,zxr,.1);
    else
        ShowImgTrk3(bimg3,param2(1:3),param2,.3,zxr,.1);
    end
    end
    %% save results
    %particle 1
    particletmp.brightness=wimg3(round(param1(2))+zcut,round(param1(1))+zcut,round(param1(3))+zcut);
    param1(1:2)=param1(1:2)+ncnt(inuc,1:2)-hs-1;
    param1(3)=param1(3)+zcut;
    particletmp.x=param1(1);
    particletmp.y=param1(2);
    particletmp.z=param1(3);
    particletmp.sigxy=param1(4);
    particletmp.sigz=param1(4)+psfparam.sigdiff;
    np.particle{inuc}.particle1=particletmp;
    %particle 2
    particletmp.brightness=[wimg3(round(param2(1,2))+zcut,round(param2(1,1))+zcut,round(param2(1,3))+zcut),...
        wimg3(round(param2(2,2))+zcut,round(param2(2,1))+zcut,round(param2(2,3))+zcut)];
    param2(:,1:2)=param2(:,1:2)+[1;1]*ncnt(inuc,1:2)-hs-1;
    param2(:,3)=param2(:,3)+zcut;
    particletmp.x=param2(:,1);
    particletmp.y=param2(:,2);
    particletmp.z=param2(:,3);
    particletmp.sigxy=param2(:,4);
    particletmp.sigz=param2(:,4)+psfparam.sigdiff;
    np.particle{inuc}.particle2=particletmp;
    % all
    np.particle{inuc}.resnorm=[resnorm1,resnorm2];
    np.particle{inuc}.resnorm_windowed=[sresnorm1,sresnorm2];
    np.particle{inuc}.isdouble=isdouble;
    %     np.pts(inuc,:)=param1;

end
end



