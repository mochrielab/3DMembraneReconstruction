function [ l1,v1,l2,v2,l3,v3 ] = DirectionalLaplacian( img )
%calculate directional laplacian sorted by egin vectors
%(removed) zxr ratio should be the zxr/psfzxr, psfzxr is the axial resolution over
%(removed) lateral resolution which is refractive index over NA
% the order of each v is x,y,z, NOT r,c,k, but v matrix and l matrix are
% r,c,k as same as image
% 3/12/2015 Yao Zhao

%% 
% construct laplacians
fxx=zeros(3,3,3);
fxx(:,:,1)=[ 1 -2 1;...
             2 -4 2;...
             1 -2 1]/16;
fxx(:,:,2)=fxx(:,:,1)*2;
fxx(:,:,3)=fxx(:,:,1);

fxy=zeros(3,3,3);
fxy(:,:,1)=[ 1 0 -1;...
             0 0 0;...
             -1 0 1]/16;
fxy(:,:,2)=fxy(:,:,1)*2;
fxy(:,:,3)=fxy(:,:,1);

fyy=permute(fxx,[2 3 1]);
fzz=permute(fxx,[3 1 2]);

fyz=permute(fxy,[2 3 1]);
fzx=permute(fxy,[3 1 2]);

imgxx=convn(img,fxx,'same');
imgyy=convn(img,fyy,'same');
imgzz=convn(img,fzz,'same');
imgxy=convn(img,fxy,'same');
imgyz=convn(img,fyz,'same');
imgzx=convn(img,fzx,'same');

newsiz=size(imgxx);
l1=zeros(newsiz);
l2=zeros(newsiz);
l3=zeros(newsiz);
v1=cell(newsiz);
v2=cell(newsiz);
v3=cell(newsiz);

for k=1:size(imgxx,3)
    for j=1:size(imgxx,2)
        for i=1:size(imgxx,1)
            covmat=[imgxx(i,j,k),   imgxy(i,j,k),   imgzx(i,j,k);...
                    imgxy(i,j,k),   imgyy(i,j,k),   imgyz(i,j,k);...
                    imgzx(i,j,k),   imgyz(i,j,k),   imgzz(i,j,k)];
            [V,D]=eig(covmat);
            [lambda,ind]=sort(diag(D));
            l1(i,j,k)=lambda(1);
            l2(i,j,k)=lambda(2);
            l3(i,j,k)=lambda(3);
            v1{i,j,k}=V(:,ind(1));
            v2{i,j,k}=V(:,ind(2));
            v3{i,j,k}=V(:,ind(3));
        end
    end
end


