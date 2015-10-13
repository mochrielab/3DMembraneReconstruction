function np= postanalysis(np)
%% decide if the data is good or bad
% create memfit that decide membrane fit quality

% %new data
% moviepath='C:\Users\YZ\Google Drive\Movie for analysis\mempar3\1827_ WT 5''';
% np.path=moviepath;
% np.loadmovie;


%%

num_nuc=np.num_nuc;
wsz=np.wsize;
hw=(wsz-1)/2;
rs=np.rs;
rstep=rs(2)-rs(1);
addnum=12;
rs=[(-addnum:-1)*rstep+rs(1),rs,rs(end)+(1:addnum)*rstep];
points=np.points;
faces=np.faces;
edges=np.edges;
neighbors=np.neighbors;
zxr=np.vox/np.pix*np.aberation;

for iframe=1:np.numframes
    %get img
    img=np.grab3(iframe);
    img1=bpass3(img,.1,5,zxr);
    %     ImgViewer3D(img1)
    for inuc=1:np.num_nuc
        nuc=np.nuclei{iframe,inuc};
        nuc_origin=nuc.origin;
        r_ind=round((nuc.r-rs(1+addnum))/rstep)+1+addnum;
        %% 3d to 2d img
        %calculate the linear index and weights for intensity matrix
        %initialize
        linearindex=nan(length(points),length(rs),4);
        weights=zeros(length(points),length(rs),4);
        %points to be interpolated
        xs=points(:,1)*rs+nuc_origin(1);
        ys=points(:,2)*rs+nuc_origin(2);
        zs=points(:,3)*rs/zxr+nuc_origin(3);
        %floors
        floor_xs=floor(xs);
        floor_ys=floor(ys);
        floor_zs=floor(zs);
        %remains
        d_xs=xs-floor_xs;
        d_ys=ys-floor_ys;
        d_zs=zs-floor_zs;
        % correct for z overshot
        zmin=floor(min(zs(:)));
        if zmin<1
            zshift=1-zmin;
        else
            zshift=0;
        end
        img1=img;
        % add slices to bottom
        for i=zmin:0
            img1=cat(3,img(:,:,1),img1);
        end
        % add slices to top
        zmax=ceil(max(zs(:)));
        for i=11:zmax
            img1=cat(3,img1,img(:,:,end));
        end
        %linear indexes of points used in interpolation
        linearindex(:,:,1)=sub2ind(size(img1),floor_ys,floor_xs,floor_zs+zshift);
        linearindex(:,:,2)=sub2ind(size(img1),floor_ys,floor_xs+1,floor_zs+zshift);
        linearindex(:,:,3)=sub2ind(size(img1),floor_ys+1,floor_xs,floor_zs+zshift);
        linearindex(:,:,4)=sub2ind(size(img1),floor_ys+1,floor_xs+1,floor_zs+zshift);
        linearindex(:,:,5)=sub2ind(size(img1),floor_ys,floor_xs,floor_zs+1+zshift);
        linearindex(:,:,6)=sub2ind(size(img1),floor_ys,floor_xs+1,floor_zs+1+zshift);
        linearindex(:,:,7)=sub2ind(size(img1),floor_ys+1,floor_xs,floor_zs+1+zshift);
        linearindex(:,:,8)=sub2ind(size(img1),floor_ys+1,floor_xs+1,floor_zs+1+zshift);
        %weights of points used in interpolation
        weights(:,:,1)=(1-d_xs).*(1-d_ys).*(1-d_zs);
        weights(:,:,2)=(d_xs).*(1-d_ys).*(1-d_zs);
        weights(:,:,3)=(1-d_xs).*(d_ys).*(1-d_zs);
        weights(:,:,4)=(d_xs).*(d_ys).*(1-d_zs);
        weights(:,:,5)=(1-d_xs).*(1-d_ys).*(d_zs);
        weights(:,:,6)=(d_xs).*(1-d_ys).*(d_zs);
        weights(:,:,7)=(1-d_xs).*(d_ys).*(d_zs);
        weights(:,:,8)=(d_xs).*(d_ys).*(d_zs);
        % 3d to 2d
        I=sum(img1(linearindex).*weights,3)';
        indtmp0=sub2ind(size(I),r_ind',1:size(I,2));

        I0=sum(I(indtmp0));
        indtmp1=sub2ind(size(I),r_ind'-addnum,1:size(I,2));
        I1=sum(I(indtmp1));
        indtmp2=sub2ind(size(I),r_ind'+addnum,1:size(I,2));
        I2=sum(I(indtmp2));
        np.nuclei{iframe,inuc}.memfit=(I1+I2)/2/I0;
    end
end
end