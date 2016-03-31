function [ obj ] = removeFourWayConnectionPoints( obj )
%remove points with only 4 conncetions
%5/27/2015 Yao Zhao
% will error when with nearby 4 way connections
% see five way connection fro correction

pts=obj.vertices;
faces=obj.faces;
edges=obj.edges;
neighbors=obj.neighbors;
numpts=size(pts,1);
numfaces=size(faces,1);
numedges=size(edges,1);

%find bad points,faces and edges

badpoints= cellfun(@length,neighbors)==4;
if sum(badpoints)>0
    numneighbors = cellfun(@length,neighbors);
    badfaces=false(numfaces,1);
    % badedges=false(numedges,1);
    badptsind=find(badpoints);
    facenew=[];
    for iibad=1:length(badptsind)
        ibad=badptsind(iibad);
        badfacetmp=(faces(:,1)==ibad | faces(:,2)==ibad | faces(:,3)==ibad);
        badfaces(badfacetmp)=1;
        nbtmp = neighbors{ibad};
        i1=nbtmp(1);
        i2=nbtmp(3);
        i3=nbtmp(2);
        i4=nbtmp(4);
        if numneighbors(i1)+numneighbors(i2) > numneighbors(i3)+numneighbors(i4)
            facenew=[facenew;i1,i3,i4;i2,i4,i3];
        else
            facenew=[facenew;i1,i3,i2;i2,i4,i1];
        end
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
    obj.calculateEdgesAndNeighbors;
end



end

