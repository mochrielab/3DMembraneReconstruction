function [obj ] = GetEdgesAndNeighbors( obj )
% return the edges and faces of a 3d mesh works
% 3/12/2015 Yao Zhao

%%

% initialize
pts=obj.vertices;
faces=obj.faces;
numpts=size(pts,1);
numfaces=size(faces,1);
numedges=numfaces*3/2;
% neighbor
neighbors=cell(numpts,1);
neighborstmp = zeros(2,20,numpts);
numneighborstmp = zeros(numpts,1);
% get edges of the faces
edgesave=zeros(numpts);
% p1, p2, f1, f2, p3, p4,
edges=zeros(numedges,6);
edgecount=0;

% for each faces
for iface=1:numfaces
    facetmp=faces(iface,:);
    % loop through 3 edges
    for ii=1:3
        edgepts=sort(facetmp((1:3~=ii)));
        thirdpts=facetmp(ii);
        % edge doesnt exist;
        if edgesave(edgepts(1),edgepts(2))==0
            % add new edge
            edgecount=edgecount+1;
            % save edge index
            edgesave(edgepts(1),edgepts(2))=edgecount;
            edgesave(edgepts(2),edgepts(1))=edgecount;
            edges(edgecount,:)=[edgepts,iface,0,thirdpts,0];
            % save neighbors
            %             neighbors{edgepts(1)}=[neighbors{edgepts(1)},[edgepts(2);thirdpts]];
            %             neighbors{edgepts(2)}=[neighbors{edgepts(2)},[edgepts(1);thirdpts]];
            
            % edge exist
        else
            % add second faces to edge
            ectmp=edgesave(edgepts(1),edgepts(2));
            edges(ectmp,4)=iface;
            edges(ectmp,6)=thirdpts;
            edgesave(edgepts(1),edgepts(2))=0;
            edgesave(edgepts(2),edgepts(1))=0;
            % save neighbors
            %             neighbors{edgepts(1)}=[neighbors{edgepts(1)},[edgepts(2);thirdpts]];
            %             neighbors{edgepts(2)}=[neighbors{edgepts(2)},[edgepts(1);thirdpts]];
        end
    end
    %5/27
    i1 = facetmp(1);
    i2 = facetmp(2);
    i3 = facetmp(3);
    numneighborstmp(i1) =  numneighborstmp(i1) + 1;
    numneighborstmp(i2) =  numneighborstmp(i2) + 1;
    numneighborstmp(i3) =  numneighborstmp(i3) + 1;
    neighborstmp(:,numneighborstmp(i1),i1) = ...
        [i2;i3];
    neighborstmp(:,numneighborstmp(i2),i2) = ...
        [i3;i1];
    neighborstmp(:,numneighborstmp(i3),i3) = ...
        [i1;i2];
end


for ipt = 1:numpts
    nbstmp = squeeze( neighborstmp(:,1:numneighborstmp(ipt),ipt) );
    % array with order
    nbarray = nbstmp(:,1)';
    nbstmp = nbstmp(:,2:end);
    while ~isempty(nbstmp)
        [row,col]=find(nbstmp==nbarray(end));
        nbarray = [nbarray, nbstmp(3-row, col)];
        nbstmp = nbstmp(:,[1:col-1,col+1:end]);
    end
    neighbors{ipt} = nbarray(1:end-1);
end

% nblength=cellfun(@length,neighbors);
% if ~isempty(find(nblength<=2,1))
%     warning('weird point');
% end
%
% if sum(edgesave(:))~= 0
%     warning('odd edge');
% end
%
% if ~isempty(find(edges(:)==0,1))
%     error('find unsigned');
% end

% patchdata.vertices=pts;
% patchdata.faces=faces;
obj.edges=edges;
obj.neighbors=neighbors;
% patchdata.edgesearch=edgesave;



end

