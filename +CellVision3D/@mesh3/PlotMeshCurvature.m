function [ obj ] = PlotMeshCurvature( obj )
%plot mesh with curvature


%%
%initialize
image3=obj.image;
cost=obj.cost;
pts=obj.vertices;
faces=obj.faces;
edges=obj.edges;
zxr=obj.zxr;
numpts=size(pts,1);
imagesz=size(image3);
p2=isosurface(image3,.5*image3);
p2.vertices(:,3)=p2.vertices(:,3)*obj.zxr;
maxnumnb=max(cellfun(@length,obj.neighbors));

neighbors=nan(numpts,maxnumnb);
for ipts=1:numpts
    nb=obj.neighbors{ipts};
    neighbors(ipts,1:length(nb))=nb;
end

neighborfaces=nan(numpts,maxnumnb);
for ipts=1:numpts
    facetmp=find(faces(:,1)==ipts | faces(:,2)==ipts | faces(:,3)==ipts);
    neighborfaces(ipts,1:length(facetmp))=facetmp';
end

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
dpts=([nx,ny,nz]-pts);


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

% get vortex normal
vertexnormal=[nfnx,nfny,nfnz];
vertexnormal=vertexnormal./(sum(vertexnormal.^2,2)*[1 1 1]);

% deviation from center projected to vertex normal
dptsn=sum(dpts.*vertexnormal,2);

for ipatch=1:obj.numpatches
    if obj.isoutward(ipatch)==0
        dptsn(obj.ptspid==ipatch)=-dptsn(obj.ptspid==ipatch);
    end
end


% plot
p1.vertices=obj.vertices;
p1.faces=obj.faces;
colorind=dptsn/.6*128+128;
colorind(colorind>254)=254;
colorind(colorind<0)=0;
colorind=floor(colorind)+1;
cm=jet(256);
rgb=cm(colorind,:);

patch(p1,'EdgeColor','none','FaceVertexCData',rgb,'FaceColor','interp');

end

