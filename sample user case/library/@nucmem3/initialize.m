function nm=initialize(nm,varargin)
%initialize analysis

%% manual continue endframe
nm.continuefrom_frame=-4;

%% initialize index and weights of linear interpolation
nm.wsize=31;
wsz=nm.wsize;
hw=(wsz-1)/2;
zxr=nm.vox/nm.pix;
zexpand = 1-floor(5.5-hw/zxr);
nm.zexpand=zexpand;
%initialize trisphere
[points,faces,edges,neighbors] = TriSphere(3);
rs=4:.3:(hw);
%save
nm.rs=rs;
nm.points=points;
nm.faces=faces;
nm.neighbors=neighbors;
nm.edges=edges;
% 
% numstacks=nm.numstacks+2*zexpand;%expanded by zshift because overshoot of rs in z
% 
% linearindex=nan(length(points),length(rs),4);
% weights=zeros(length(points),length(rs),4);
% xs=points(:,1)*rs+hw+1;
% ys=points(:,2)*rs+hw+1;
% zs=points(:,3)*rs/zxr+5.5+zexpand;%increased because overshoot of rs in z
% 
% floor_xs=floor(xs);
% floor_ys=floor(ys);
% floor_zs=floor(zs);
% 
% d_xs=xs-floor_xs;
% d_ys=ys-floor_ys;
% d_zs=zs-floor_zs;
% %linear indexes of points used in interpolation
% % floor_zs(floor(zs)<1|floor(zs)>9)=nan;
% linearindex(:,:,1)=sub2ind([wsz,wsz,numstacks],floor_ys,floor_xs,floor_zs);
% linearindex(:,:,2)=sub2ind([wsz,wsz,numstacks],floor_ys,floor_xs+1,floor_zs);
% linearindex(:,:,3)=sub2ind([wsz,wsz,numstacks],floor_ys+1,floor_xs,floor_zs);
% linearindex(:,:,4)=sub2ind([wsz,wsz,numstacks],floor_ys+1,floor_xs+1,floor_zs);
% linearindex(:,:,5)=sub2ind([wsz,wsz,numstacks],floor_ys,floor_xs,floor_zs+1);
% linearindex(:,:,6)=sub2ind([wsz,wsz,numstacks],floor_ys,floor_xs+1,floor_zs+1);
% linearindex(:,:,7)=sub2ind([wsz,wsz,numstacks],floor_ys+1,floor_xs,floor_zs+1);
% linearindex(:,:,8)=sub2ind([wsz,wsz,numstacks],floor_ys+1,floor_xs+1,floor_zs+1);
% %weights of points used in interpolation
% weights(:,:,1)=(1-d_xs).*(1-d_ys).*(1-d_zs);
% weights(:,:,2)=(d_xs).*(1-d_ys).*(1-d_zs);
% weights(:,:,3)=(1-d_xs).*(d_ys).*(1-d_zs);
% weights(:,:,4)=(d_xs).*(d_ys).*(1-d_zs);
% weights(:,:,5)=(1-d_xs).*(1-d_ys).*(d_zs);
% weights(:,:,6)=(d_xs).*(1-d_ys).*(d_zs);
% weights(:,:,7)=(1-d_xs).*(d_ys).*(d_zs);
% weights(:,:,8)=(d_xs).*(d_ys).*(d_zs);
% 
% % linearindex(isnan(linearindex))=wsz*wsz*numstacks+1;
% nm.linearindex=linearindex;
% nm.weights=weights;
%% allocate data cell
% r=zeros(length(points),1);
% cellformat.r=r;
% cellformat.volume=[];
% cellformat.center=[];
% cellformat.window_center=[];
% cellformat.contour=[];
nm.nuclei=repmat({[]},nm.endframe,nm.num_nuc);

% close all;
end

