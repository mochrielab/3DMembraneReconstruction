function [ obj ] = BalanceTopology( obj )
%perform a topology switch on the mesh works
%try to balance connection
% 3/12/2015 Yao Zhao
% 5/27/2015 added if statement of the neighbor number before topology
% switch

%% initialize
pts=obj.vertices;
faces=obj.faces;
edges=obj.edges;
neighbors=obj.neighbors;
num_neighbors=cellfun(@length,neighbors);
min_neighbor_number = obj.min_neighbor_number;
max_neighbor_number = obj.max_neighbor_number;
% min_neighbor_number = 5;
% max_neighbor_number = 6;
numpts=size(pts,1);
numfaces=size(faces,1);
numedges=size(edges,1);

%sort faces
faces=sort(faces,2);

% topological switch
for iedge=1:numedges
    % choose next edge
    edgetmp=edges(iedge,:);
    i1=edgetmp(1);
    i2=edgetmp(2);
    if i1>=i2
        error('edges are not sorted');
    end
    % changed edge connection!! cant trust the third points
    %     i3=edgetmp(5);
    %     i4=edgetmp(6);
    %     f1=edgetmp(3);
    %     f2=edgetmp(4);
    % search to get faces
    fs=find( (faces(:,1)==i1 & faces(:,2)==i2) ...
        | (faces(:,2)==i1 & faces(:,3)==i2) ...
        | (faces(:,1)==i1 & faces(:,3)==i2));
    if length(fs)~=2
        i1
        i2
        fs
        error('wrong number of faces');
    end
    f1=fs(1);
    f2=fs(2);
    % search face to get the third points instead
    f1pts=faces(f1,:);
    f2pts=faces(f2,:);
    i3=f1pts(f1pts~=i1 & f1pts~=i2);
    i4=f2pts(f2pts~=i1 & f2pts~=i2);
    if length(i3) ~=1 || length(i4)~=1
        error('find multiple points');
    elseif i3==i4
        warning('find same point');
    end
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
    %     if  (e13*e23'<0 || e14*e24'<0) && (e13*e14'>0 && e23*e24'>0 ) %
    %     above is another choice
    %if ((e13*e23'<0) + (e14*e24'<0)) > ((e13*e14'<0) + (e23*e24'<0)) ... try with out angle
    if (num_neighbors(i1)+num_neighbors(2) > num_neighbors(i3)+num_neighbors(i4) ...
            || ((e13*e23'<0) + (e14*e24'<0)) >= ((e13*e14'<0) + (e23*e24'<0)) ) ...
            && num_neighbors(i1) > min_neighbor_number ...
            && num_neighbors(i2) > min_neighbor_number ...
            && num_neighbors(i3) < max_neighbor_number ...
            && num_neighbors(i4) < max_neighbor_number ...
            
        % switch edges
        % switch faces
        faces(f1,:)= sort([i1 i3 i4]);
        faces(f2,:)= sort([i2 i3 i4]);
        
        % update number of neighbors
        num_neighbors(i1) = num_neighbors(i1) - 1;
        num_neighbors(i2) = num_neighbors(i2) - 1;
        num_neighbors(i3) = num_neighbors(i3) + 1;
        num_neighbors(i4) = num_neighbors(i4) + 1;
        
        % dont change edge here, useless, recalculate afterward
        %             edges(iedge,:)=[i3 i4 f1 f2 i1 i2];
        %             % remove neighbor and adde neighbor
        %             neighbors{i1}=deletenb(neighbors{i1},i2);
        %             neighbors{i2}=deletenb(neighbors{i2},i1);
        %             neighbors{i3}=addnb(neighbors{i3},i4);
        %             neighbors{i4}=addnb(neighbors{i4},i3);
    end
end

obj.faces=faces;
obj.GetEdgesAndNeighbors;
%%
if obj.diagnostic_mod_on==1
    obj.DiagnoseMeshTopology;
end


end

% function y=addnb(xs,x)
% y=[xs,x];
% end
%
% function y=deletenb(xs,x)
% if ~isempty(find(xs==x,1))
%     y=xs(xs~=x);
% else
%     warning('cant find neighbors to delete');
% end
% end


