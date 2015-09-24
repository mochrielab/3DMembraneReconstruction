function [ obj ] = RemoveThreeWayConnectionPoints( obj )
%remove points with only 3 conncetions
% 5/27/2015 , Yao Zhao
% will error when two 3 way connection consecutive

pts=obj.vertices;
faces=obj.faces;
edges=obj.edges;
neighbors=obj.neighbors;
numpts=size(pts,1);
numfaces=size(faces,1);
numedges=size(edges,1);

% remove small triangle by removing points who has only 3 neighbors
%find bad points,faces and edges

badpoints= cellfun(@length,neighbors)==3;
if sum(badpoints)>0
%     display(['remove bad points ',num2str(sum(badpoints))])
    badfaces=false(numfaces,1);
    % badedges=false(numedges,1);
    badptsind=find(badpoints);
    facenew=[];
    for iibad=1:length(badptsind)
        ibad=badptsind(iibad);
        badfacetmp=(faces(:,1)==ibad | faces(:,2)==ibad | faces(:,3)==ibad);
        badfaces(badfacetmp)=1;
        % create new face
        allind=faces(badfacetmp,:);
        ind4=unique(allind);
        ind3=ind4(ind4~=ibad);
        facenew=[facenew;ind3'];
    end
 
    faces=[faces;facenew];
    badfaces=[badfaces;false(size(facenew,1),1)];
    %remove bad stuff
    pts=pts(~badpoints,:);
    faces=faces(~badfaces,:);
    % new faces, edge lookup table to old stuff
    ptslookup= cumsum(~badpoints);
    % update values in faces and edges
    for ic=1:3
        faces(:,ic)=ptslookup(faces(:,ic));
    end
    
    obj.vertices=pts;
    obj.faces=faces;
    obj.GetEdgesAndNeighbors;
end



if obj.diagnostic_mod_on==1
    obj.DiagnoseMeshTopology;
end

end

