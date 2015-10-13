function [ obj ] = AnalyzeParticleCorrelation( obj, channels, varargin)
%calculate the particle motion correlation
%based on channels, channels cell for channel name string
% first channel main channel
% 6/24/2015
% Yao Zhao
%%
for imod=1:nargin-2
    if strcmp(varargin{imod},'fissionyeast_SPB_other')
        channel1=channels{1};
        channel2=channels{2};
        %%
        clear result;
        for icell=1:obj.numdata
            % get particle
            particle1=obj.data(icell).(channel1).particle;
            pos1=[particle1.value;];
            pos1=reshape(pos1,5,length(pos1)/5)';
            particle2=obj.data(icell).(channel2).particle;
            pos2=[particle2.value;];
            pos2=reshape(pos2,5,length(pos2)/5)';
            cnt=[obj.data(icell).contour.center,obj.data(icell).contour.focalplane];
            % correct drift and zxr
            p1=pos1(:,1:3)-obj.drift-ones(obj.numframes,1)*cnt;
            p1(:,3)=p1(:,3)*obj.zxr;
            p2=pos2(:,1:3)-obj.drift-ones(obj.numframes,1)*cnt;
            p2(:,3)=p2(:,3)*obj.zxr;
            % project to new axis system
            theta=obj.data(icell).contour.theta;
            nx=[cos(theta),-sin(theta),0];
            ny=[sin(theta),cos(theta),0];
            [posnew1,nx,ny,nz]=rotate3dto(nx,ny,p1);
            [posnew2,nx,ny,nz]=rotate3dto(nx,ny,p2);
            x1=posnew1(:,2);
            y1=posnew1(:,3);
            z1=posnew1(:,1);
            x2=posnew2(:,2);
            y2=posnew2(:,3);
            z2=posnew2(:,1);
            
            % project to spherical coordinate
            [a1,e1,r1]=cart2sph(x1,y1,z1);
            da1=diff(a1);
            da1(da1<-pi)=da1(da1<-pi)+2*pi;
            da1(da1>pi)=da1(da1>pi)-2*pi;
            a1=a1(1)+[0;cumsum(da1)];
            [a2,e2,r2]=cart2sph(x2,y2,z2);
            da2=diff(a2);
            da2(da2<-pi)=da2(da2<-pi)+2*pi;
            da2(da2>pi)=da2(da2>pi)-2*pi;
            a2=a2(1)+[0;cumsum(da2)];

            % project to spreaded map cooridnate
            re1=cumsum([0;diff(e1).*r1(2:end)]);
            ra1=cumsum([0;diff(a1).*r1(2:end).*cos(e1(2:end))]);
            rr1=r1/mean(r1);
            re2=cumsum([0;diff(e2).*r2(2:end)]);
            ra2=cumsum([0;diff(a2).*r2(2:end).*cos(e2(2:end))]);
            rr2=r2/mean(r1); % intentionally use r1 here
            
            % save center position, and other position
            cs.center1=[mean(x1),mean(y1),mean(z1)];
            cs.sphcenter1=[mean(a1),mean(e1),mean(r1)];
            cs.pos1=[x1,y1,z1];
            cs.sph1=[a1,e1,r1];
            cs.sphr1=[re1,ra1,rr1];
            cs.center2=[mean(x2),mean(y2),mean(z2)];
            cs.sphcenter2=[mean(a2),mean(e2),mean(r2)];
            cs.pos2=[x2,y2,z2];
            cs.sph2=[a2,e2,r2];
            cs.sphr2=[re2,ra2,rr2];
            
            % calculate correlation
            cs.var1=[var(x1),var(y1),var(z1)];
            cs.var2=[var(x2),var(y2),var(z2)];
            cs.cov2to1z=[cov(x2,z1),cov(y2,z1),cov(z2,z1)];
            
            % get major axis correlation for x,y,z space
            cm1=cov([x1,y1,z1]);
            [vecs1,lambda1]=eig(cm1);
            [~,indtmp]=sort(diag(lambda1));
            v1=vecs1(:,indtmp(3));
            l1=sum([x1,y1,z1].*(ones(length(x1),1)*v1'),2);
            cm2=cov([x2,y2,z2]);
            [vecs2,lambda2]=eig(cm2);
            [~,indtmp]=sort(diag(lambda2));
            v2=vecs2(:,indtmp(3));
            l2=sum([x2,y2,z2].*(ones(length(x1),1)*v2'),2);
            cs.cov2mto1m=cov(l2,l1);
            
            % find the max correlation axis for x,y,z space 6/24/2015
            cm1=cov([x1,y1,z1]);
            [vecs1,lambda1]=eig(cm1);
            [~,indtmp]=sort(diag(lambda1));
            v1=vecs1(:,indtmp(3));
            l1=sum([x1,y1,z1].*(ones(length(x1),1)*v1'),2);
            cmx2l1=cov(x2,l1);
            cmy2l1=cov(y2,l1);
            cmz2l1=cov(z2,l1);
            maxcoraxis=[cmx2l1(3),cmy2l1(3),cmz2l1(3)];
            maxcoraxis=maxcoraxis/norm(maxcoraxis);
            l2maxcoraxis=sum([x2,y2,z2].*(ones(length(x1),1)*maxcoraxis),2);
            cs.cov2mto1max=cov(l2maxcoraxis,l1);
            
            % get spherical variance
            cs.varsph1=[var(ra1),var(re1),var(rr1)];
            cs.varsph2=[var(ra2),var(re2),var(rr2)];
            cs.cov2to1e=[cov(ra2,re1),cov(re2,re1),cov(rr2,re1)];
            
            % get spread map major cor to re1
            cmr2=cov([ra2,re2,rr2]);
            [vecsr2,lambdar2]=eig(cmr2);
            [~,indtmp]=sort(diag(lambdar2));
            vr2=vecsr2(:,indtmp(3));
            lr2=sum([ra2,re2,rr2].*(ones(length(x1),1)*vr2'),2);
            cs.cov2mto1e=cov(lr2,re1);
            
            % auto correlation 6/24/2015
            cs.autocor1=autocorr(l1,obj.numframes-1);
            cs.autocor2=autocorr(l2maxcoraxis,obj.numframes-1);
            cs.cross=crosscorr(l1,l2maxcoraxis,obj.numframes-1);
            
            % saveresult
            result(icell)=cs;
            
            % test plot
            if 0
                colors=hsv(obj.numchannels+2);
                clf;
                % get cell contour
                contour=obj.data(icell).contour;
                [xc, yc, z2] = ellipsoid(0,0,0,contour.length/2,contour.width/2,contour.width/2);
                % plot cell contour
                h1=surfl(xc, yc, z2);
                set(h1,'EdgeColor','none','FaceColor',colors(obj.numchannels+1,:),'FaceAlpha',0.1);
                hold on;
                camlight
                lighting gouraud
                axis equal;
                % plot nuclei contour
                [xn, yn, zn] = ellipsoid(0,0,0,.9*contour.width/2,.9*contour.width/2,.9*contour.width/2);
                h2=surfl(xn, yn, zn);
                set(h2,'EdgeColor','none','FaceColor',colors(obj.numchannels+2,:),'FaceAlpha',0.1);
                hold on;
                plot3(posnew1(:,1),posnew1(:,2),posnew1(:,3),'o-',...
                    'color',colors(2,:),...
                    'linewidth',1);hold on;
                plot3(posnew1(1,1),posnew1(1,2),posnew1(1,3),'ko')
                hold on;
                plot3(posnew2(:,1),posnew2(:,2),posnew2(:,3),'o-',...
                    'color',colors(1,:),...
                    'linewidth',1);hold on;
                plot3(posnew2(1,1),posnew2(1,2),posnew2(1,3),'ko')
                hold on;
                legend([{'cell'},{'nuclei'},obj.channelnames']);
                view([0 1 0])
                pause
            end
        end
        obj.result=result;
    end
    
end

