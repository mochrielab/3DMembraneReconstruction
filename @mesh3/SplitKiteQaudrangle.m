function [ obj ] = SplitKiteQaudrangle( obj,th)
%break the Kite qaudrangles of mesh networks
% threshold is for triangle with length bigger than th
% 3/12/2015 Yao Zhao
% currently broke

%% initialize
pts=obj.vertices;
faces=obj.faces;
edges=obj.edges;
neighbors=obj.neighbors;
edgesearch=obj.edgesearch; % deleted 5/25
% edgesearch = obj.edges; % added 5/25

numpts=size(pts,1);
numfaces=size(faces,1);
numedges=size(edges,1);


facedelete=[];
edgedelete=[];

addnb=@(xs,x)[xs,x];
deletenb=@(xs,x)xs(xs~=x);

numedges0=numedges;
% topological switch
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
    p3=pts(i3,:);
    p4=pts(i4,:);
    %edges
    e13=p3-p1;
    e23=p3-p2;
    e14=p4-p1;
    e24=p4-p2;
    % decide switch or add point
    if  (e13*e23'<0 || e14*e24'<0)
        % switch edges
        if ~(e13*e14'>0 && e23*e24'>0 ) && norm(p4-p3)>2
            % add point
            newpts=(p3+p4)/2;
            pts=[pts;newpts];
            numpts=numpts+1;
            inew=numpts;
            % delete face
            facedelete=[facedelete;f1;f2];
            % add face
            faces=[faces;i1 inew i3; inew i2 i3; i1 i4 inew; i4 i2 inew];
            fn13=numfaces+1;
            fn23=numfaces+2;
            fn14=numfaces+3;
            fn24=numfaces+4;
            numfaces=numfaces+4;
            % tell other edge about the face change
            edges(edgesearch(i1,i3),:)=...
                EdgeUpdateFace(i1,i3,i2,edgesearch,edges,inew,fn13);
            edges(edgesearch(i2,i3),:)=...
                EdgeUpdateFace(i2,i3,i1,edgesearch,edges,inew,fn23);
            edges(edgesearch(i1,i4),:)=...
                EdgeUpdateFace(i1,i4,i2,edgesearch,edges,inew,fn14);
            edges(edgesearch(i2,i4),:)=...
                EdgeUpdateFace(i2,i4,i1,edgesearch,edges,inew,fn24);
            % delete edge
            edgedelete=[edgedelete;iedge];
            % add edge
            edges=[edges; i1 inew fn13 fn14 i3 i4;...
                i2 inew fn23 fn24 i3 i4;...
                i3 inew fn13 fn23 i1 i2;...
                i4 inew fn14 fn24 i1 i2];
            e1=numedges+1;
            e2=numedges+2;
            e3=numedges+3;
            e4=numedges+4;
            numedges=numedges+4;
            % update edge search
            edgesearch=[edgesearch,zeros(numpts-1,1);zeros(1,numpts-1),0];
            edgesearch(i1,inew)=e1;
            edgesearch(i2,inew)=e2;
            edgesearch(i3,inew)=e3;
            edgesearch(i4,inew)=e4;
            edgesearch(inew,:)=edgesearch(:,inew)';
            % remove neighbor
            neighbors{i1}=deletenb(neighbors{i1},i2);
            neighbors{i2}=deletenb(neighbors{i2},i1);
            neighbors{i3}=deletenb(neighbors{i3},i4);
            neighbors{i4}=deletenb(neighbors{i4},i3);
            % add neighbor
            neighbors{i1}=addnb(neighbors{i1},inew);
            neighbors{i2}=addnb(neighbors{i2},inew);
            neighbors{i3}=addnb(neighbors{i3},inew);
            neighbors{i4}=addnb(neighbors{i4},inew);
            neighbors=[neighbors;{[i1 i2 i3 i4]}];
        end
    end
end

% delete edges
edgekeep=ones(numedges,1);
edgekeep(edgedelete)=0;
edges=edges(logical(edgekeep),:);

% update new face index in edges
facekeep=ones(numfaces,1);
facekeep(facedelete)=0;
facelookup=cumsum(facekeep);
edges(:,3)=facelookup(edges(:,3));
edges(:,4)=facelookup(edges(:,4));

% delete faces
faces=faces(logical(facekeep),:);

%% save data
obj.vertices=pts;
obj.faces=faces;
obj.edges=edges;
obj.neighbors=neighbors;

end

function [newedge]=EdgeUpdateFace(istart,iend,fichange,edgesearch,edges,inew,fnew)
    newedge=edges(edgesearch(istart,iend),:);
%     edgesearch(istart,iend)
%     newedge
%     fichange
    changeind=find(newedge([5 6])==fichange);
    if isempty(changeind)
        error('cant find');
    end
    newedge(changeind+4)=inew;
    newedge(changeind+2)=fnew;
end


