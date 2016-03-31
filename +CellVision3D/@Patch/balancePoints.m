function [ obj ] = balancePoints( obj )
%balance the distribution of points based on the mean center
% 3/12/2015 Yao Zhao
% 5/27/2015 added volume balancing rather than mean center balancing



%% initialize
pts=obj.vertices;
faces=obj.faces;
edges=obj.edges;
neighbors=obj.neighbors;
numpts=size(pts,1);
numfaces=size(faces,1);
numedges=size(edges,1);
% % a matrix to help search edges index by start and end vertices points  % added 5/25
% edgesearch = zeros(numpts+numedges,numpts+numedges);
% for iedge=1:numedges0
%     edgesearch(edges(iedge,1),edges(iedge,2))=iedge;
%     edgesearch(edges(iedge,2),edges(iedge,1))=iedge;
% end

%loop through all the points
for ipt=1:numpts
    % calculate center of mass for edges
    nbs = neighbors{ipt}';
    nbpts = pts(nbs,:);
    nbpts2 = nbpts([2:end,1],:);
    p0 = pts(ipt,:);
    % center for each edge
    edge_center = ( nbpts + nbpts2 ) / 2;  
    % weight for each edge
    edge_weight = sqrt(sum( (nbpts2-nbpts).^2 , 2));
    % center of mass
    cnt = sum(edge_center .* (edge_weight*[1 1 1]) ,1) / sum(edge_weight);
    % calculate area normal
    narea = sum(cross(nbpts-ones(size(nbpts,1),1)*cnt,nbpts2-ones(size(nbpts,1),1)*cnt),1);
    narea = narea/norm(narea);
    % modify center
    pts(ipt,:) = cnt + (p0-cnt)*(narea')*narea; % try a factor of 1/2
    
    
    
    % volume is not accurate enough, use center of mass instead
%     % total vol, could be positive or negative, doesnt matter here
%     p0 = pts(ipt,:);
%     param = zeros(length(nbs),3);
%     vol = 0 ;
%     nbs_ext = [nbs; nbs(1)];
%     for inb = 1 : length(nbs)
%         p2 = nbs_ext(inb);
%         p3 = nbs_ext(inb+1);
%         param(inb,:) = 1/6 * cross(p2-cnt , p3-cnt);
%         vol = vol + ( param(inb,:) * (p0-cnt)' );
%     end
%     vol_mean = vol / length(nbs);
%     % calculate new center that minimize that sum(v_i - v_bar)^2
%     pts(ipt,:) = cnt + ...
%         ( (param'*param)^-1*(param'*ones(length(nbs),1)*vol_mean)  )';
%     %     pts(ipts,:)=mean(nbpts);



end

% end
obj.vertices=pts;



end

