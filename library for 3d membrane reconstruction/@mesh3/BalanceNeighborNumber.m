function [ obj ] = BalanceNeighborNumber( obj )
% split or merge vertices to balance the number of neighbors for each
% vertices
% neighbor_number_range is a [1 by 2] vector that tells the optimal range
% of number of neighbors
% 5/26/2015 Yao Zhao
% not completed, balance topology include some sort of number number
% balancing



[underconnect,overconnect] = NeighborConnection(obj);
% solve all bad connection
count=0;
while sum(underconnect) + sum(overconnect) > 0
    pts=obj.vertices;
    faces=obj.faces;
    edges=obj.edges;
    findfirst = find(underconnect+overconnect,1);
    % if underconnect
    if underconnect(findfirst) == 1
    % if overconnect
    elseif overconnect(findfirst) ==1
        nb1=obj.neighbors{findfirst};
        nb2=[nb1(2:end),nb1(1)];
        p0=ones(length(nb1),1)*pts(findfirst,:);
        p1=pts(nb1,:);
        p2=pts(nb2,:);
        angles=sum(p1-p0.*p2-p0,2);
        [~,tmpind]=max(angles);
        i1_0=nb1(tmpind);
        i2_0=nb2(tmpind);
        i1=min([i1_0,i2_0]);
        i2=max([i1_0,i2_0]);
        pts=pts([1:i2-1,i2+1:end],:);
        ptslookup=[1:i2-1,i1,i2:size(pts,1)];
        edgedelete=edges(edges(:,1)==i1 & edges(:,2)==i2,:);
        facedelete=sort(edgedelete([3,4]));
        faces=faces([1:facedelete(1)-1,facedelete(1)+1:facedelete(2)-1,...
            facedelete(2)+1:end],:);
        for ic=1:3
            faces(:,ic)=ptslookup(faces(:,ic));
        end
    end
    count=count+1
    obj.vertices=pts;
    obj.faces=faces;
    obj.GetEdgesAndNeighbors;
    obj.BalanceTopology;
    obj.PlotMeshSim;pause(.1);
    [underconnect,overconnect] = NeighborConnection(obj);
end

end
% 
function [underconnect,overconnect] = NeighborConnection(obj)
    underconnect = (cellfun(@length,obj.neighbors)<obj.min_neighbor_number);
    overconnect = (cellfun(@length,obj.neighbors)>obj.max_neighbor_number);
end


% pts=obj.vertices;
% faces=obj.faces;
% edges=obj.edges;
% neighbors=obj.neighbors;
% numpts=size(pts,1);
% numfaces=size(faces,1);
% numedges=size(edges,1);
% %% loop through each vertices
% neighbor_face=zeros(numpts,15);
% neighbor_face_i2=zeros(numpts,15);
% neighbor_face_i3=zeros(numpts,15);
% neighbor_number=zeros(numpts,1);
% neighbor_face_cos=zeros(numpts,1);
% for iface=1:faces
%     % init
%     i1=faces(iface,1);
%     i2=faces(iface,2);
%     i3=faces(iface,3);
%     p1=pts(i1,:);
%     p2=pts(i2,:);
%     p3=pts(i3,:);
%     neighbor_number([i1,i2,i3])=neighbor_number([i1,i2,i3])+1;
%     % number
%     np1=neighbor_number(i1);
%     np2=neighbor_number(i2);
%     np3=neighbor_number(i3);
%     % face index
%     neighbor_face(i1,np1) = iface;
%     neighbor_face(i2,np2) = iface;
%     neighbor_face(i3,np3) = iface;
%     % vertex 1 index
%     neighbor_face_i2(i1,np1) = i2;
%     neighbor_face_i3(i1,np1) = i3;
%     % vertex 2 index
%     neighbor_face_i2(i2,np2) = i3;
%     neighbor_face_i3(i2,np2) = i1;
%     % vertex 3 index
%     neighbor_face_i2(i3,np3) = i1;
%     neighbor_face_i3(i3,np3) = i2;
%     % face cosine
%     neighbor_face_cos(i1,np1) = abs(norm(p2-p1)*norm(p3-p1)');
%     neighbor_face_cos(i2,np2) = abs(norm(p3-p2)*norm(p1-p2)');
%     neighbor_face_cos(i3,np3) = abs(norm(p1-p3)*norm(p2-p3)');
% end
% 
% for ipts=1:numpts
%     % if too few neighbors
%     if neighbor_number(ipts) < min_neighbor_number
% %         % split a wide triangle into 2
% %         [~,indtmp]=max(neighbor_face_cos(ipts,1:neighbor_number(ipts)));
% %         % split p3 to p2
% %         i2 = neighbor_face_i2(ipts,indtmp);
% %         i3 = neighbor_face_i3(ipts,indtmp);
%         % 
%     % if two many neighbors     
%     elseif neighbor_number(ipts) > max_neighbor_number
%         % combine 2 sharpest triangle into 1
%                 face_cos_tmp = ...
%             sort(neighbor_face_cos(ipts,neighbor_number(ipts)),'descend');
%     end
% end
