function [ nm ] = correct_drift( nm, varargin )
%%


if nargin==1
    fNorm = .2;  % f/samplingf -> .01 very low pass filter  -> 1 no filter
    ignore_r_new=0;
elseif nargin==2
    fNorm=varargin{1};
    ignore_r_new=0;
elseif nargin==3
    fNorm=varargin{1};
    ignore_r_new=varargin{2};
end
order = 5;      % order of filter -> lowest is 1, highest is whatever
[b,a] = butter(order, fNorm, 'low');
zxr=nm.vox/nm.pix;
points=nm.points;
faces=nm.faces;

%% search all instead of second neighbor
px=points(:,1);
py=points(:,2);
pz=points(:,3);

fc=(points(faces(:,1),:)+points(faces(:,2),:)+points(faces(:,3),:))/3;

fx2=ones(length(px),1)*fc(:,1)';
fy2=ones(length(px),1)*fc(:,2)';
fz2=ones(length(px),1)*fc(:,3)';

%% correct drift
for inuc=1:nm.num_nuc
    %% filter origin
    cnt=zeros(nm.endframe,3);
    ocnt=zeros(nm.endframe,3);
    for iframe=1:nm.endframe
        nuc=nm.nuclei{iframe,inuc};
        cnt(iframe,:)=nuc.center;
        ocnt(iframe,:)=nuc.origin;
    end
    fcnt = filtfilt(b, a, cnt);
    mcnt=mean(cnt,1);
    mcnt=ones(size(cnt,1),1)*mcnt;
    corcnt=fcnt-ocnt;
    corcnt(:,3)=corcnt(:,3)*zxr;
    %% interpolate
    for iframe=1:nm.endframe
        nuc=nm.nuclei{iframe,inuc};
  
        if ~ignore_r_new
            x_old=points(:,1).*nuc.r-corcnt(iframe,1);
            y_old=points(:,2).*nuc.r-corcnt(iframe,2);
            z_old=points(:,3).*nuc.r-corcnt(iframe,3);
            r_old=sqrt(x_old.^2+y_old.^2+z_old.^2);
            nx_old=(x_old./r_old)*ones(1,size(fc,1));
            ny_old=(y_old./r_old)*ones(1,size(fc,1));
            nz_old=(z_old./r_old)*ones(1,size(fc,1));
            points_old=[x_old,y_old,z_old];
            dist2=sqrt((nx_old-fx2).^2+(ny_old-fy2).^2+(nz_old-fz2).^2);
            [sd2,sortI]=sort(dist2,2);
            i1=faces(sortI(:,1),1);
            i2=faces(sortI(:,1),2);
            i3=faces(sortI(:,1),3);
            
            p1=points_old(i1,:);
            p2=points_old(i2,:);
            p3=points_old(i3,:);
            
            facevec=cross(p3-p2,p2-p1,2);
            facenorm=facevec./sqrt(sum(facevec.^2,2)*[1 1 1]);
            d1=(sum(p1.*facenorm,2));
            d2=(sum(points.*facenorm,2));
            pi=((d1./d2)*[1 1 1]).*points;
            ri=sqrt(sum(pi.^2,2));
            nuc.r_new=ri;
        end
        fcenter=fcnt(iframe,:);
        nuc.origin_new=fcenter;
        nm.nuclei{iframe,inuc}=nuc;
        %% test plot
        if 0
            clf
            pts1=[nuc.r.*points(:,1),nuc.r.*points(:,2),nuc.r.*points(:,3)];
            patch1.vertices=pts1;
            patch1.faces=faces;
            pts2=[nuc.r_new.*points(:,1),nuc.r_new.*points(:,2),nuc.r_new.*points(:,3)];
            pts2=pts2+ones(size(pts2,1),1)*corcnt(iframe,:);
            patch2.vertices=pts2;
            patch2.faces=faces;
            
            patch(patch1,'FaceColor','g','EdgeColor','none','FaceAlpha',0.3);hold on;
            patch(patch2,'FaceColor','r','EdgeColor','none','FaceAlpha',.3);hold on;
            view(3);
            axis([-10 10 -10 10 -10 10])
            daspect([1 1 1])
            grid off
            camlight
            lighting gouraud
            pause
        end
    end
    %     clf
    %     plot(cnt-mcnt);
    %     hold on;
    %     plot(fcnt-mcnt);
    %     pause(1);
end

end