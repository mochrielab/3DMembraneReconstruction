function [ obj ] = FitSurface( obj, varargin )
%search for the best surface of the 3d membrane
% search along the vertex normal direction
% 3/14/2015 Yao Zhao

%%
%
if nargin == 1
    searchconst = 0;
elseif nargin == 2
    searchconst = varargin{1};
end

%initialize
image3=obj.image;
cost=obj.cost;
pts=obj.vertices;
faces=obj.faces;
edges=obj.edges;
zxr=obj.zxr;
numpts=size(pts,1);
imagesz=size(image3);
% p2=isosurface(image3,.5*image3);
% p2.vertices(:,3)=p2.vertices(:,3)*obj.zxr;
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

% set search direction bias
% searchconst=0;%0.01;
if obj.isoutward
    searchconst=-searchconst;
end

% construct minfun
fmin=@(ptsin)FminSurf(ptsin,cost,image3,faces,edges,neighbors,neighborfaces,searchconst,zxr);

pts0=pts;
lb=ones(numpts,1)*[2 2 2*zxr];
ub=ones(numpts,1)*[imagesz(2),imagesz(1),(imagesz(3)-1)*zxr];
options = optimoptions('fmincon','MaxFunEvals',1e4,...
    'GradObj','on','display','final','TolX',1e-3);
pts = fmincon(fmin,pts0,[],[],[],[],lb,ub,[],options);
%     pts-pts0

obj.vertices=pts;

% clf
% p1.faces=obj.faces;
% p1.vertices=pts;
% SP(p1,[],'k',.5);
% SP(p2,'b',[],.5);
% legend('fitted','original');

% if ~isempty(obj.vertexnormals)
% % pc=(pts(faces(:,1),:)+pts(faces(:,2),:)+pts(faces(:,3),:))/3;
% vn=obj.vertexnormals;
% % fn=obj.facenormals;
% pp=pts;
% nn=vn;
% if obj.isoutward==0
%     nn=-nn;
% end
% hold on;
% quiver3(pp(:,1),pp(:,2),pp(:,3),nn(:,1),nn(:,2),nn(:,3),'color','y');
% end


% pause
% end
%%

%% shell image fit surface tesing codes
% %initialize
% shellimage=obj.shellimage;
% cost=0;%1e-4;
% rs=(-obj.shellstepnum:obj.shellstepnum)*obj.shellstep;
% numrs=length(rs);
% pts=obj.vertices;
% vertexnormals=obj.vertexnormals;
% neighbors=obj.neighbors;
% edge12=obj.edges(:,1:2);
% nn=cellfun(@length,neighbors);
%
% % construct minfun
% fmin=@(ind)FminSurfMax(ind,cost,shellimage,rs,pts,vertexnormals,edge12,nn);
% % fit them all
% tic
%     [~,ind0]=max(shellimg,[],1);
%     ind0(ind0==1)=2;
%     ind0(ind0==numrs)=numrs-1;
%     lb=1.01*ones(size(ind0));
%     ub=(numrs-0.01)*ones(size(ind0));
%     options = optimoptions('fmincon','MaxFunEvals',1e8,'GradObj','off','display','iter');
%     dind = fmincon(fmin,ind0,[],[],[],[],lb,ub,[],options);
% toc
%
% dr=(dind'-1)*(rs(2)-rs(1))+rs(1);
% ptsnew=pts+dr*[1 1 1].*vertexnormals;


end

