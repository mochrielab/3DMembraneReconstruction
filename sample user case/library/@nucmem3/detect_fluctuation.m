function nm=detect_fluctuation(nm)
% detect fluctuation for each nuclei


% important parameters, find peak that is 0.4 pixel for 12.5 seconds
% peak finding threshold
peak_th=0.3;%0.25;%
% image smoothing
gauss_xy=2;
gauss_t=2;
% tracking parameter
tparam.dim=2;
tparam.maxdisp=5;
tparam.mem=2;
tparam.good=3;%10
[ points2,faces2,psi,theta] = setup_img( );

% track extension parameter
rootpath='C:\nuclei';
trjextwz=20;
if ~exist([rootpath,'\flucpics'],'dir')
    mkdir([rootpath,'\flucpics']);
end

f=figure('Position',[100 100 1200 900]);

trjfluc=cell(1,nm.num_nuc);
%% go through all the nuclei
for inuc=1:nm.num_nuc
    %image extension for gaussian filter
    extsiz=10;
    % half window size for particle finding, centroid caculation, periodic expansion
    hpsiz=16;
    %
    otmp=nm.orientation(inuc);
    % calculate mean contour
    sum_r=0;
    for iframe=1:nm.endframe
        sum_r=sum_r+nm.nuclei{iframe,inuc}.r_new;
    end
    mean_r=sum_r/nm.endframe;
    meannuc=nm.nuclei{1,inuc};
    meannuc.r_new=mean_r;
    meannuc=centralband(meannuc,nm,points2,size(psi),1);
    mean_img=meannuc.img;
    mean_img = shift_image( mean_img, otmp, 0 );
    mean_img_ext=[mean_img(:,end-hpsiz+1:end),mean_img,mean_img(:,1:hpsiz)];
    mean_img_ext=[zeros(hpsiz,size(mean_img_ext,2));...
        mean_img_ext;zeros(hpsiz,size(mean_img_ext,2))];
    
    % construct 3d image series and filtered image;
    time_img=zeros(size(psi,1)+2*hpsiz,size(psi,2)+2*extsiz+2*hpsiz,nm.endframe);
    for iframe=1:nm.endframe
        nuc=nm.nuclei{iframe,inuc};
        img=nuc.img;
        img = shift_image( img, otmp, 0 );
        dimg=(img-mean_img);%./mean_img;
        dimg=[dimg(:,end-hpsiz+1:end),dimg,dimg(:,1:hpsiz)];
        dimg=[zeros(hpsiz,size(dimg,2));...
            dimg;zeros(hpsiz,size(dimg,2))];
        time_img(:,:,iframe)=[dimg(:,end-extsiz+1:end),dimg,dimg(:,1:extsiz)];
    end
    % filter the data
    time_img_filtered=gausspass3(time_img,gauss_xy,gauss_t);
    time_img_filtered=time_img_filtered(:,extsiz+1:end-extsiz,:);
    time_img=time_img(:,extsiz+1:end-extsiz,:);
    % calculate std
    std_img=std(time_img,1,3);
    
    % find peaks and params for each image
    pos=[];
    for iframe=1:nm.endframe
        %filtered img
        ext_img_filtered=squeeze(time_img_filtered(:,:,iframe));
        ext_img=squeeze(time_img(:,:,iframe));
        %origin img
        % tracks must have peak value higher than peak_th
        pks=pkfnd(ext_img_filtered,peak_th,hpsiz);
        
        %                 %filter out near cap peaks, do not filter peaks, filter
        %                 %tracks instead
        %                 if ~isempty(pks)
        %                     pks=pks(pks(:,2)>=hpsiz+5 & pks(:,2)<=hpsiz+15,:);
        %                 end
        % getting specs for the peaks
        cnt=[];
        if ~isempty(pks)
            for ipeak=1:size(pks,1)
                wimg_filtered=ext_img_filtered(pks(ipeak,2)+(-hpsiz:hpsiz),pks(ipeak,1)+(-hpsiz:hpsiz));
                wimg=ext_img(pks(ipeak,2)+(-hpsiz:hpsiz),pks(ipeak,1)+(-hpsiz:hpsiz));
                bw=wimg_filtered>0.5*wimg_filtered(hpsiz+1,hpsiz+1);
                wimg_weight=zeros(size(wimg_filtered));
                wimg_weight(bw)=wimg_filtered(bw);
                [imy,imx]=meshgrid(pks(ipeak,2)+(-hpsiz:hpsiz),pks(ipeak,1)+(-hpsiz:hpsiz));
                my=mean(mean(wimg_weight.*imy))/mean(wimg_weight(:));
                mx=mean(mean(wimg_weight.*imx))/mean(wimg_weight(:));
                cnt=[cnt;mx,my,...pks(:,1),pks(:,2),...
                    wimg(hpsiz+1,hpsiz+1),wimg_weight(hpsiz+1,hpsiz+1),sqrt(sum(bw(:)))];
            end
            %saving
            pos=[pos;cnt,iframe+zeros(size(cnt,1),1)];
        end
    end
    % connect the trajectories
    tracksfull=[];
    if ~isempty(pos)
        tracksfull=yaotrack(pos,tparam);
    end
    
    % extend all the trajectories
    tracks_ext=[];
    endframe=nm.endframe;
    if ~isempty(tracksfull)
        for itrj=1:tracksfull(end,end)
            trjtmp=tracksfull(tracksfull(:,end)==itrj,:);
            meanlong=mean(trjtmp(:,1));
            meanlat=mean(trjtmp(:,2));
            if ~isempty(trjtmp) ...
                    ... && meanlat>hpsiz+5 && meanlat<hpsiz+15 ...
                    && meanlong>hpsiz && meanlong<hpsiz+64
                t_start=trjtmp(1,end-1);
                t_end=trjtmp(end,end-1);
                mx_start=trjtmp(1,1);
                mx_end=trjtmp(end,1);
                my_start=trjtmp(1,2);
                my_end=trjtmp(end,2);
                pre_ts=(max(1,t_start-trjextwz):t_start-1)';
                post_ts=(t_end+1:min(endframe,t_end+trjextwz))';
                pre_x=zeros(size(pre_ts))+round(mx_start);
                pre_y=zeros(size(pre_ts))+round(my_start);
                post_x=zeros(size(post_ts))+round(mx_end);
                post_y=zeros(size(post_ts))+round(my_end);
                pre_h=squeeze(time_img_filtered(round(my_start),round(mx_start),pre_ts));
                post_h=squeeze(time_img_filtered(round(my_end),round(mx_end),post_ts));
                pre_h0=squeeze(time_img(round(my_start),round(mx_start),pre_ts));
                post_h0=squeeze(time_img(round(my_end),round(mx_end),post_ts));
                pre_w=zeros(size(pre_ts));
                post_w=zeros(size(post_ts));
                pre_ind=zeros(size(pre_ts))+itrj;
                post_ind=zeros(size(post_ts))+itrj;
                tracks_ext=[tracks_ext;pre_x,pre_y,pre_h0,pre_h,pre_w,pre_ts,pre_ind;...
                    trjtmp;post_x,post_y,post_h0,post_h,post_w,post_ts,post_ind];
            end
        end
    end
    trjfluc{inuc}=tracks_ext;
    %% plot
    clf
    % centerline kemograph
    axes('Position',[0.075 0.45 0.4 0.5]);
    img_centerline=(squeeze(time_img_filtered(10+hpsiz,:,:)))';
    %             img_centerline=[img_centerline(:,end-hpsiz+1:end),img_centerline,img_centerline(:,1:hpsiz)];
    imagesc(img_centerline*0.16,[-0.05,0.2]);colormap jet;hold on;
    plot([hpsiz hpsiz+64;hpsiz hpsiz+64],[0 0;250 250],'r');
    xlabel('angle')
    ylabel('time (s)')
    title('longitude centerline fluctuation kymograph')
    colorbar;hold on;
    set(gca,'XTick',(0:16:64)+hpsiz);
    set(gca,'YTick',(0:20:100),'YTicklabel',(0:20:100)*2.5);
    set(gca, 'xticklabel', '0 | p/2 | p | 3p/2 | 2p', 'fontname', 'symbol');
    if ~isempty(tracks_ext)
        for itj=1:tracks_ext(end,end)
            trtmp=tracks_ext(tracks_ext(:,end)==itj,:);
            if ~isempty(trtmp)
                xtr=trtmp(:,1);%-hpsiz;
                ytr=trtmp(:,2);%-hpsiz;
                ttr=trtmp(:,end-1);
                plot(xtr,ttr,'.-k');hold on;%,'Color',GenColor(itj/tracks(end,4)));hold on;
            end
        end
    end
    %% max kemograph
    axes('Position',[0.575 0.45 0.4 0.5]);
    max_longi=(squeeze(max(time_img_filtered,[],1)))';
    %             max_longi=[max_longi(:,end-hpsiz+1:end),max_longi,max_longi(:,1:hpsiz)];
        imagesc(max_longi*0.16,[-0.05,0.2]);colormap jet;hold on;
                plot([hpsiz hpsiz+64;hpsiz hpsiz+64],[0 0;250 250],'r');
    xlabel('angle')
    ylabel('time (s)')
    title('longitude max fluctuation kymograph')
    colorbar;hold on;
    set(gca,'XTick',(0:16:64)+hpsiz);
    set(gca,'YTick',(0:20:100),'YTicklabel',(0:20:100)*2.5);
    set(gca, 'xticklabel', '0 | p/2 | p | 3p/2 | 2p', 'fontname', 'symbol');
    
    if ~isempty(tracks_ext)
        for itj=1:tracks_ext(end,end)
            trtmp=tracks_ext(tracks_ext(:,end)==itj,:);
            if ~isempty(trtmp)
                xtr=trtmp(:,1);%-hpsiz;
                ytr=trtmp(:,2);%-hpsiz;
                ttr=trtmp(:,end-1);
                plot(xtr,ttr,'.-k');hold on;%,'Color',GenColor(itj/tracks(end,4)));hold on;
            end
        end
    end
    
    %% std map
    axes('Position',[0.05 0.05 0.55 0.3]);
    imagesc(std_img(hpsiz+1:end-hpsiz,:)*0.16,[0.02 0.15]);colormap jet;axis image;colorbar;hold on;
                   plot([hpsiz hpsiz+64;hpsiz hpsiz+64],[1 1;19 19],'r'); hold on;
    if ~isempty(tracks_ext)
        for itj=1:tracks_ext(end,end)
            trtmp=tracks_ext(tracks_ext(:,end)==itj,:);
            if ~isempty(trtmp)
                xtr=trtmp(:,1);%-hpsiz;
                ytr=trtmp(:,2)-hpsiz;
                plot(xtr,ytr,'.-k');hold on;%,'Color',GenColor(itj/tracks(end,4)));hold on;
            end
        end
    end
    title('standard deviation map');
    xlabel('longitudinal angle')
    ylabel('latitudinal angle')
    set(gca,'XTick',(0:16:64)+hpsiz);
    set(gca, 'xticklabel', '0 | p/2 | p | 3p/2 | 2p', 'fontname', 'symbol');
    set(gca,'YTick',([2,10,18]));
    set(gca, 'yticklabel', '-p/4 | 0 | p/4', 'fontname', 'symbol');
    
    %% plot all the tracks
    axes('Position',[0.7 0.075 0.275 0.25]);
    if ~isempty(tracks_ext)
        for itrj=1:tracks_ext(end,end)
            trjtmp=tracks_ext(tracks_ext(:,end)==itrj,:);
            trjh=trjtmp(:,4);
            trjh0=trjtmp(:,3);%unfiltered height is very noisy, filtered result is good for time analysis
            %                     plot(trjtmp(:,end-1),trjh);hold on;
            if ~isempty(trjtmp)
                ts=trjtmp(:,end-1)*2.5;
                hs=trjh*0.16;
                fitfun=@(P)risefall(P,ts)-hs;
                [~,maxheightind]=max(trjh);
                p0=[ts(maxheightind),10,10,0.3,-0.1];
                lb=[ts(1),5,5,0.05,-0.15];
                ub=[ts(end),ts(end)-ts(1),...
                    ts(end)-ts(1),0.5,0.05];
                options=optimset('Display','off');
                p=lsqnonlin(fitfun,p0,lb,ub,options);
                plot(ts,hs);hold on;
                plot(ts,risefall(p,ts),'r');hold on;
                legend('raw fluctuation','fit to triangle wave')
            end
            title('peak detection');xlabel('time(seconds)');ylabel('height(\mum)');
            
        end
    end
    FigureFormat(f);
    print(f,[rootpath,'\flucpics\',nm.filename,'_',num2str(inuc)],'-dpng');
end
nm.trj=trjfluc;
%     save(fullfile(path,'\data',filename),'nm');
%     nm.save_contour(1);


%%
    clf;
    imagesc(std_img(hpsiz+1:end-hpsiz,:)*0.16,[0.02 0.15]);colormap jet;axis image;colorbar;hold on;
                   plot([hpsiz hpsiz+64;hpsiz hpsiz+64],[0 0;20 20],'w'); hold on;
    if ~isempty(tracks_ext)
        for itj=1:tracks_ext(end,end)
            trtmp=tracks_ext(tracks_ext(:,end)==itj,:);
            if ~isempty(trtmp)
                xtr=trtmp(:,1);%-hpsiz;
                ytr=trtmp(:,2)-hpsiz;
                plot(xtr,ytr,'.-k');hold on;%,'Color',GenColor(itj/tracks(end,4)));hold on;
            end
        end
    end
    title('standard deviation map');
    xlabel('longitudinal angle')
    ylabel('latitudinal angle')
    set(gca,'XTick',(0:16:64)+hpsiz);
    set(gca, 'xticklabel', '0 | p/2 | p | 3p/2 | 2p', 'fontname', 'symbol');
    set(gca,'YTick',([2,10,18]));
    set(gca, 'yticklabel', '-p/4 | 0 | p/4', 'fontname', 'symbol');
    FigureFormat(gcf)
    %%
    clf
    img_centerline=(squeeze(time_img_filtered(13+hpsiz,:,:)))';
    %             img_centerline=[img_centerline(:,end-hpsiz+1:end),img_centerline,img_centerline(:,1:hpsiz)];
    imagesc(img_centerline*0.16,[-0.05,0.2]);colormap jet;hold on;
    plot([hpsiz hpsiz+64;hpsiz hpsiz+64],[0 0;250 250],'w');
    xlabel('angle')
    ylabel('time (s)')
    title('longitude centerline fluctuation kymograph')
    colorbar;hold on;
    set(gca,'XTick',(0:16:64)+hpsiz);
    set(gca,'YTick',(0:20:100),'YTicklabel',(0:20:100)*2.5);
    set(gca, 'xticklabel', '0 | p/2 | p | 3p/2 | 2p', 'fontname', 'symbol');
    if ~isempty(tracks_ext)
        for itj=1:tracks_ext(end,end)
            trtmp=tracks_ext(tracks_ext(:,end)==itj,:);
            if ~isempty(trtmp)
                xtr=trtmp(:,1);%-hpsiz;
                ytr=trtmp(:,2);%-hpsiz;
                ttr=trtmp(:,end-1);
                plot(xtr,ttr,'.-k');hold on;%,'Color',GenColor(itj/tracks(end,4)));hold on;
            end
        end
    end
    FigureFormat(gcf)
    %%
    clf
    if ~isempty(tracks_ext)
        for itrj=1:tracks_ext(end,end)
            trjtmp=tracks_ext(tracks_ext(:,end)==itrj,:);
            trjh=trjtmp(:,4);
            trjh0=trjtmp(:,3);%unfiltered height is very noisy, filtered result is good for time analysis
            %                     plot(trjtmp(:,end-1),trjh);hold on;
            if ~isempty(trjtmp)
                ts=trjtmp(:,end-1)*2.5;
                hs=trjh*0.16;
                fitfun=@(P)risefall(P,ts)-hs;
                [~,maxheightind]=max(trjh);
                p0=[ts(maxheightind),10,10,0.3,-0.1];
                lb=[ts(1),5,5,0.05,-0.15];
                ub=[ts(end),ts(end)-ts(1),...
                    ts(end)-ts(1),0.5,0.05];
                options=optimset('Display','off');
                p=lsqnonlin(fitfun,p0,lb,ub,options);
                plot(ts,hs);hold on;
                plot(ts,risefall(p,ts),'r');hold on;
                legend('raw fluctuation','fit to triangle wave')
            end
            title('peak detection');xlabel('time(seconds)');ylabel('height(\mum)');
            
        end
    end
    FigureFormat(f);
 
end

