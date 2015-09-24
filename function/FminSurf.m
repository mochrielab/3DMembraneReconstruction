function [ fmin, varargout ] = FminSurf(pts,cost,image3,faces,edges,neighbors,neighborfaces,searchconst,zxr)
%function to minimize for surface reconstruction
% pts: position for each vertex, numpts*3
% cost: computational penalty on surface bending
% image3: preprocessed movie
% faces: face connection matrix, numfaces*3
% edges: edges information, p1 p2 f1 f2 ,numedges*4
% 3/14/2015 Yao Zhao

%%

% interp image3
imgsz=size(image3);
fx=floor(pts(:,1));
fy=floor(pts(:,2));
fz=floor(pts(:,3)/zxr);
dx=pts(:,1)-fx;
dy=pts(:,2)-fy;
dz=pts(:,3)/zxr-fz;

I=   image3(sub2ind(imgsz,fy,fx,fz)).*(1-dx).*(1-dy).*(1-dz) ...
    +image3(sub2ind(imgsz,fy,fx,fz+1)).*(1-dx).*(1-dy).*(dz) ...
    +image3(sub2ind(imgsz,fy,fx+1,fz)).*(dx).*(1-dy).*(1-dz) ...
    +image3(sub2ind(imgsz,fy,fx+1,fz+1)).*(dx).*(1-dy).*(dz) ...
    +image3(sub2ind(imgsz,fy+1,fx,fz)).*(1-dx).*(dy).*(1-dz) ...
    +image3(sub2ind(imgsz,fy+1,fx,fz+1)).*(1-dx).*(dy).*(dz) ...
    +image3(sub2ind(imgsz,fy+1,fx+1,fz)).*(dx).*(dy).*(1-dz) ...
    +image3(sub2ind(imgsz,fy+1,fx+1,fz+1)).*(dx).*(dy).*(dz) ;
%

% get center of neighbor points
x=pts(:,1);
y=pts(:,2);
z=pts(:,3);
nx=nan(size(neighbors));
ny=nan(size(neighbors));
nz=nan(size(neighbors));
choosenb=~isnan(neighbors);
nx(choosenb)=x(neighbors(choosenb));
nx=mean(nx,2,'omitnan');
ny(choosenb)=y(neighbors(choosenb));
ny=mean(ny,2,'omitnan');
nz(choosenb)=z(neighbors(choosenb));
nz=mean(nz,2,'omitnan');
% deviation from neighbor center
dpts=pts-[nx,ny,nz]; %5/29 flipped sign
% dpts=([nx,ny,nz]-pts); 


% face normal
p1=pts(faces(:,1),:);
p2=pts(faces(:,2),:);
p3=pts(faces(:,3),:);
p21=p2-p1;
p32=p3-p2;
dirarea=1/2*cross(p21,p32,2);
facearea= sqrt(sum(dirarea.^2,2));
facenormals= dirarea./(facearea*ones(1,3));

% get nieghbor average face normal
fnx=facenormals(:,1);
fny=facenormals(:,2);
fnz=facenormals(:,3);
nfnx=nan(size(neighborfaces));
nfny=nan(size(neighborfaces));
nfnz=nan(size(neighborfaces));
choosenbface=~isnan(neighborfaces);
nfnx(choosenbface)=fnx(neighborfaces(choosenbface));
nfnx=mean(nfnx,2,'omitnan');
nfny(choosenbface)=fny(neighborfaces(choosenbface));
nfny=mean(nfny,2,'omitnan');
nfnz(choosenbface)=fnz(neighborfaces(choosenbface));
nfnz=mean(nfnz,2,'omitnan');

% get area for each vertices 6/2
ptsarea=nan(size(neighborfaces));
ptsarea(choosenbface) = facearea(neighborfaces(choosenbface));
ptsarea = mean(ptsarea,2,'omitnan');
% size(ptsarea)

% get vortex normal
vertexnormal=[nfnx,nfny,nfnz];
vertexnormal=vertexnormal./(sum(vertexnormal.^2,2)*[1 1 1]);

% deviation from center projected to vertex normal
dptsn=sum(dpts.*vertexnormal,2)*([1 1 1]).*vertexnormal;
dptsn2=dptsn.^2;

% fmin function to miminize
% fmin=-sum(I(:)) + cost*sum(dptsn2(:)); 
fmin=-sum(I) + cost*sum(sum(dptsn2,2)./ptsarea); %6/2 added area normalizer

% function grad
if nargout>1
    gradIx= -image3(sub2ind(imgsz,fy,fx,fz)).*(1-dy).*(1-dz) ...
        -image3(sub2ind(imgsz,fy,fx,fz+1)).*(1-dy).*(dz) ...
        +image3(sub2ind(imgsz,fy,fx+1,fz)).*(1-dy).*(1-dz) ...
        +image3(sub2ind(imgsz,fy,fx+1,fz+1)).*(1-dy).*(dz) ...
        -image3(sub2ind(imgsz,fy+1,fx,fz)).*(dy).*(1-dz) ...
        -image3(sub2ind(imgsz,fy+1,fx,fz+1)).*(dy).*(dz) ...
        +image3(sub2ind(imgsz,fy+1,fx+1,fz)).*(dy).*(1-dz) ...
        +image3(sub2ind(imgsz,fy+1,fx+1,fz+1)).*(dy).*(dz) ;
    
    gradIy= -image3(sub2ind(imgsz,fy,fx,fz)).*(1-dx).*(1-dz) ...
        -image3(sub2ind(imgsz,fy,fx,fz+1)).*(1-dx).*(dz) ...
        -image3(sub2ind(imgsz,fy,fx+1,fz)).*(dx).*(1-dz) ...
        -image3(sub2ind(imgsz,fy,fx+1,fz+1)).*(dx).*(dz) ...
        +image3(sub2ind(imgsz,fy+1,fx,fz)).*(1-dx).*(1-dz) ...
        +image3(sub2ind(imgsz,fy+1,fx,fz+1)).*(1-dx).*(dz) ...
        +image3(sub2ind(imgsz,fy+1,fx+1,fz)).*(dx).*(1-dz) ...
        +image3(sub2ind(imgsz,fy+1,fx+1,fz+1)).*(dx).*(dz) ;
    
    gradIz= -image3(sub2ind(imgsz,fy,fx,fz)).*(1-dx).*(1-dy) ...
        +image3(sub2ind(imgsz,fy,fx,fz+1)).*(1-dx).*(1-dy) ...
        -image3(sub2ind(imgsz,fy,fx+1,fz)).*(dx).*(1-dy) ...
        +image3(sub2ind(imgsz,fy,fx+1,fz+1)).*(dx).*(1-dy) ...
        -image3(sub2ind(imgsz,fy+1,fx,fz)).*(1-dx).*(dy) ...
        +image3(sub2ind(imgsz,fy+1,fx,fz+1)).*(1-dx).*(dy) ...
        -image3(sub2ind(imgsz,fy+1,fx+1,fz)).*(dx).*(dy) ...
        +image3(sub2ind(imgsz,fy+1,fx+1,fz+1)).*(dx).*(dy) ;
    
    % get neighbor average of dpts
    dpx=dpts(:,1);
    dpy=dpts(:,2);
    dpz=dpts(:,3);
    dnx=nan(size(neighbors));
    dny=nan(size(neighbors));
    dnz=nan(size(neighbors));
    
    dnx(choosenb)=dpx(neighbors(choosenb));
    dnx=mean(dnx,2,'omitnan');
    dny(choosenb)=dpy(neighbors(choosenb));
    dny=mean(dny,2,'omitnan');
    dnz(choosenb)=dpz(neighbors(choosenb));
    dnz=mean(dnz,2,'omitnan');
    
    % final grad output
    grad=[-gradIx+2*cost*(dpx-dnx)./(ptsarea),...
        -gradIy+2*cost*(dpy-dny)./(ptsarea),...
        -gradIz+2*cost*(dpz-dnz)./(ptsarea)];

% % major bug corrected 6/2 ???
%     grad=[-gradIx+2*cost*(dpx+dnx)./(ptsarea),...
%         -gradIy+2*cost*(dpy+dny)./(ptsarea),...
%         -gradIz+2*cost*(dpz+dnz)./(ptsarea)];
%     

    % project the final grad to the vertex normal direction
    varargout{1} = (sum(grad.*vertexnormal,2)+searchconst)*[1 1 1].*vertexnormal;

end

end

% toc
%%

% %points
% tic
% p1=pts(faces(:,1),:);
% p2=pts(faces(:,2),:);
% p3=pts(faces(:,3),:);
% fc=(p1+p2+p3)/3;
%
% % face normal
% p21=p2-p1;
% p32=p3-p2;
% dirarea=1/2*cross(p21,p32,2);
% facearea= sqrt(sum(dirarea.^2,2));
% facenormals= dirarea./(facearea*ones(1,3));
% toc
%
% tic
% % calcualte the vertex normal
% vertexnormals=zeros(numpts,3);
% for ifaces=1:numfaces
%     for j=1:3
%     vertexnormals(faces(ifaces,j),:)=...
%         vertexnormals(faces(ifaces,j),:)+facenormals(ifaces,:);
%     end
% end
% vertexnormals=vertexnormals./(sqrt(sum(vertexnormals.^2,2))*ones(1,3));
% toc

% tic
% % interp image3
% imgsz=size(image3);
% fx=floor(fc(:,1));
% fy=floor(fc(:,2));
% fz=floor(fc(:,3)/zxr);
% dx=fc(:,1)-fx;
% dy=fc(:,2)-fy;
% dz=fc(:,3)/zxr-fz;
% I=   image3(sub2ind(imgsz,fy,fx,fz)).*(1-dx).*(1-dy).*(1-dz) ...
%     +image3(sub2ind(imgsz,fy,fx,fz+1)).*(1-dx).*(1-dy).*(dz) ...
%     +image3(sub2ind(imgsz,fy,fx+1,fz)).*(dx).*(1-dy).*(1-dz) ...
%     +image3(sub2ind(imgsz,fy,fx+1,fz+1)).*(dx).*(1-dy).*(dz) ...
%     +image3(sub2ind(imgsz,fy+1,fx,fz)).*(1-dx).*(dy).*(1-dz) ...
%     +image3(sub2ind(imgsz,fy+1,fx,fz+1)).*(1-dx).*(dy).*(dz) ...
%     +image3(sub2ind(imgsz,fy+1,fx+1,fz)).*(dx).*(dy).*(1-dz) ...
%     +image3(sub2ind(imgsz,fy+1,fx+1,fz+1)).*(dx).*(dy).*(dz) ;
% toc
%
% tic
% % face bending cost
% fn1=facenormals(edges(:,3),:);
% fn2=facenormals(edges(:,4),:);
% edgelength= sqrt(sum((pts(edges(:,1),:)-pts(edges(:,2),:)).^2,2));
% angle12=1-sum(fn1.*fn2,2);
% toc
%
% % fmin
% fmin1=-sum(I.*facearea)/sum(facearea);
% fmin2= cost*sum(angle12.*edgelength)/sum(edgelength);
% fmin=fmin1+fmin2;
%
% if nargout>1
%
% end

% fmin1
% fmin2


