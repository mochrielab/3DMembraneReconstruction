function [ obj ] = RemoveNearbyFiveWayConnectionPoints( obj )
%remove the edge that is between two five way connections
% when two nearby vertices are all five way connected
% it will merge those two

% bugged currently, i think the reason is that removing too many 5 way
% connection may result in points with two few connections
% maybe move less point at each time or constant check for under connected
% points will solve this bug


pts=obj.vertices;
faces=obj.faces;
edges=obj.edges;
neighbors=obj.neighbors;
% numneighbors=cellfun(@length,neighbors);
% numpts=size(pts,1);
% numfaces=size(faces,1);
% numedges=size(edges,1);

badedges=FindNearbyFiveWayEdges(edges,neighbors);
while sum(badedges)>0
    
    %%%%%%%% remove this in the future
    edges=obj.edges;
    neighbors=obj.neighbors;
    %%%%%%%%%%%%%%%%%%%%
    
    % mark edges to be deleted
    edgedelete = find(badedges,1);
    % mark faces to be deleted
    facedelete = sort(edges(edgedelete,[3,4]));
    % mark vertices to be deleted
    i1=edges(edgedelete,1);
    i2=edges(edgedelete,2);
    ptsdelete = i2;
    % change position of i1
    pts(i1,:)=pts(i1,:)/2+pts(i2,:)/2;
    % delete i2
    pts=pts([1:ptsdelete-1,ptsdelete+1:end],:);
    % replace i2 link to i1
    ptslookup = [1:ptsdelete-1,i1,ptsdelete:size(pts,1)];
    %update faces for pts
    for ic=1:3
        faces(:,ic)=ptslookup(faces(:,ic));
    end
    %update edges for pts
    for ic=[1,2,5,6]
        edges(:,ic)=ptslookup(edges(:,ic));
    end
    %delete faces
    faces= faces([1:facedelete(1)-1,facedelete(1)+1:facedelete(2)-1,...
        facedelete(2)+1:end],:);
%     facelookup=[1:facedelete(1)-1,0,facedelete(1):facedelete(2)-2,0,...
%         facedelete(2)-1:size(faces)];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% quick to program but time consuming
    obj.vertices=pts;
    obj.faces=faces;
    obj.GetEdgesAndNeighbors;
%     obj.PlotMeshSim;pause
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% bugged fast version below, should fix
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% this and replace above
    
%     %delete edges
%     edges=edges([1:edgedelete-1,edgedelete+1:end],:);
%     % update edges for faces change
%     edges(:,3)=facelookup(edges(:,3));
%     edges(:,4)=facelookup(edges(:,4));
%     
%     %update neighbors
%     n1=neighbors{i1};
%     n2=neighbors{i2};
%     neighbors{i1} = unique([n1(n1~=i2),n2(n2~=i1)]); %% order not preserved!!!! need to recalculate neighbors
%     % delete i2 from neighbor points
%     for inb=neighbors{i1}
%         inb
%         neighbors{inb}=neighbors{inb}(neighbors{inb}~=i2);
%     end
%     % delete i2's neighbors
%     neighbors=neighbors([1:ptsdelete-1,ptsdelete+1:end]);
%     % update neighbor pts
%     for inb=1:length(neighbors)
%         neighbors{inb}=ptslookup(neighbors{inb});
%     end
    % update badedges
    badedges=FindNearbyFiveWayEdges(edges,neighbors);
end

obj.vertices=pts;
obj.faces=faces;
obj.GetEdgesAndNeighbors;

if obj.diagnostic_mod_on==1
    obj.DiagnoseMeshTopology;
end

end

function [badedges] = FindNearbyFiveWayEdges(edges,neighbors)
badedges=zeros(size(edges,1),1);
for iedge=1:size(edges,1)
    i1=edges(iedge,1);
    i2=edges(iedge,2);
    %         badedges(iedge) = numneighbors(i1)==5 && ...
    %             numneighbors(i2) == 5;
    badedges(iedge) = length(neighbors{i1})==5 && ...
        length(neighbors{i2}) == 5;
end
end

