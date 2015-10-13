function [ fmin, varargout ] = FminSurfMax(ind,cost,shellimage,rs,pts,vertexnormals,edge12,nn)
%function to minimize for surface reconstruction
% index: index array of fitted surface, 1*numpts
% cost: computational penalty on surface bending
% surfimage: surface interpolated image, numrs*numpts
% rs: shell distance array, numrs*1
% pts: position for each vertex, numpts*3
% vertexnormals: vertex normal direcions, numpts*3
% neighbors: neighbors of each point, cell(numpts,1)
% edge12: edge matrix of all edge connection, numedges*2
% nn: number of neighbors for each points, numpts*1
% 3/14/2015 Yao Zhao

%%
% round index 
ind1=floor(ind);
ind2=ind1+1;
dind=ind-ind1;

% interpolated intensity
[numrs,numpts]=size(shellimage);

I = shellimage(sub2ind([numrs,numpts],ind1,1:numpts)).*(1-dind) ...
    + shellimage(sub2ind([numrs,numpts],ind2,1:numpts)).*(dind);  

% deviation from point center
dr=(ind-1)*(rs(2)-rs(1))+rs(1);

% new pts
pts=pts+vertexnormals.*(dr'*[1 1 1]);
% % get all number average dr
% ndr=zeros(size(dr));
% for ipts=1:numpts
%     npts=pts(neighbors{ipts},:);
%     ndr(ipts)=mean((npts-ones(size(npts,1),1)*pts(ipts,:)),1)*vertexnormals(ipts,:)';
% end
numedge=size(edge12,1);
e1=edge12(:,1);
e2=edge12(:,2);
edgesum=sum((sum(pts(e1,:).*vertexnormals(e2,:),2)./nn(e1)).^2 + ...
    (sum(pts(e2,:).*vertexnormals(e1,:),2)./nn(e2)).^2);

% function to minize
fmin=-sum(I(:))/numrs/numpts+cost*edgesum/2/numedge;

% -sum(I(:))/numrs/numpts
% cost*edgesum/2/numedge

end

