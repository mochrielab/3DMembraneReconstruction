function [ obj ] = SplitLargeQaudrangle( obj, th )
%break qaudrangles of mesh networks which has edge length larger than th
% threshold is for triangle with length bigger than th, unit of pixels
% 5/26/2015 Yao Zhao
% this method doesnt work that well
% try to remodel based on number of neighbors

%% initialize
pts=obj.vertices;
faces=obj.faces;
edges=obj.edges;

numpts=size(pts,1);
numfaces=size(faces,1);
numedges=size(edges,1);
% number of original edges and points
numedges0=numedges;
numpts0 = numpts;

% pre assign extended matrix
pts = [pts;zeros(numedges,3)];
faces = [faces;zeros(numedges*4,3)]; 
edges = [edges;zeros(numedges*4,6)]; 

% a matrix to help search edges index by start and end vertices points  % added 5/25
edgesearch = zeros(numpts+numedges,numpts+numedges);
for iedge=1:numedges0
    edgesearch(edges(iedge,1),edges(iedge,2))=iedge;
    edgesearch(edges(iedge,2),edges(iedge,1))=iedge;
end


% save face index to be deleted
facedelete=[];
% edgedelete=[];
%
% addnb=@(xs,x)[xs,x];
% deletenb=@(xs,x)xs(xs~=x);


% loop through all previous edges
for iedge=1:numedges0
    % choose next edge
    edgetmp=edges(iedge,:);
    i1=edgetmp(1);
    i2=edgetmp(2);
    i3=edgetmp(5);
    i4=edgetmp(6);
    f1=edgetmp(3);
    f2=edgetmp(4);
    
    %points
    p1=pts(i1,:);
    p2=pts(i2,:);
    
    %edges
    e12=p2-p1;
    
    % if the edge is larger than threshold break it
    if norm( e12 ) > th
        % add point
        newpts=(p1+p2)/2;
        pts(numpts+1,:)=newpts;
        numpts=numpts+1;
        inew=numpts;
        % delete face
        facedelete=[facedelete;f1;f2];
        % add face
        fn13=numfaces+1;
        fn23=numfaces+2;
        fn14=numfaces+3;
        fn24=numfaces+4;
        faces(numfaces+1:numfaces+4,:)=...
            [i1 inew i3; inew i2 i3; i1 i4 inew; i4 i2 inew];
        numfaces=numfaces+4;
        % tell other edge about the face change
%         if edgesearch(i1,i3)*edgesearch(i2,i3)*edgesearch(i1,i4)*edgesearch(i2,i4)==0
%             SI(edgesearch)
%         end
        edges(edgesearch(i1,i3),:)=...
            EdgeUpdateFace(i1,i3,i2,edgesearch,edges,inew,fn13);
        edges(edgesearch(i2,i3),:)=...
            EdgeUpdateFace(i2,i3,i1,edgesearch,edges,inew,fn23);
        edges(edgesearch(i1,i4),:)=...
            EdgeUpdateFace(i1,i4,i2,edgesearch,edges,inew,fn14);
        edges(edgesearch(i2,i4),:)=...
            EdgeUpdateFace(i2,i4,i1,edgesearch,edges,inew,fn24);
        % delete edge
%         edgedelete=[edgedelete;iedge];
        % add edge
        e1=numedges+1;
        e2=numedges+2;
        e3=numedges+3;
        e4=numedges+4;
        edges(numedges+1:numedges+4,:) = ...
          [ i1 inew fn13 fn14 i3 i4;...
            i2 inew fn23 fn24 i3 i4;...
            i3 inew fn13 fn23 i1 i2;...
            i4 inew fn14 fn24 i1 i2];
        numedges=numedges+4;
        
        % update edge search
%        edgesearch=[edgesearch,zeros(numpts-1,1);zeros(1,numpts-1),0];
        edgesearch(i1,inew)=e1;
        edgesearch(i2,inew)=e2;
        edgesearch(i3,inew)=e3;
        edgesearch(i4,inew)=e4;
        edgesearch(inew,:)=edgesearch(:,inew)';
        % not neccesary to update neighbors, will calculate later
        
    end
end


% update new face index in edges
facekeep=ones(numfaces,1);
facekeep(facedelete)=0;
faces=faces(logical(facekeep),:);

%% save data
obj.vertices=pts(1:numpts,:);
obj.faces=faces;
obj.GetEdgesAndNeighbors;
end

function [newedge]=EdgeUpdateFace(istart,iend,fichange,edgesearch,edges,inew,fnew)
% initialize replacing edge
newedge=edges(edgesearch(istart,iend),:);
% find the index of vertices to be replaced
changeind=find(newedge([5 6])==fichange);
if isempty(changeind)
    error('cant find');
elseif length(changeind) > 1
    error('find more than 1 index');
end
% update the opposite point of edges
newedge(changeind+4)=inew;
% update the face of the edge
newedge(changeind+2)=fnew;
end


