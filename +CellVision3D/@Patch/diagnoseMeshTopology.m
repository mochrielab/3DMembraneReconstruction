function [ obj ] = DiagnoseMeshTopology( obj )
%test if the mesh topology is ok...
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
% get edges of the faces
edgesave=zeros(numpts);
% p1, p2, f1, f2, p3, p4,
edges=zeros(numedges,6);
edgecount=0;

% examin uniqueness of each face
faces=sort(faces,2);
facesnew=sortrows(faces,[1 2 3]);
facediff=diff(facesnew).^2;
for i=1:size(facediff,1)
    if sum(facediff(i,:))==0
        warning('find two same faces');
    end
end

% for each faces
for iface=1:numfaces
    facetmp=faces(iface,:);
    combo=[1 2;2 1;1 3;3 1;2 3;3 2];
    for i=1:size(combo,1)
        edgesave(facetmp(combo(i,1)),facetmp(combo(i,2)))=...
            edgesave(facetmp(combo(i,1)),facetmp(combo(i,2)))+1;
%         edgesave(facetmp(combo(i,2)),facetmp(combo(i,1)))=...
%             edgesave(facetmp(combo(i,2)),facetmp(combo(i,1)))+1;
    end
    combof=[1 2 3;2 1 3; 3 1 2];
    for i=1:3
        neighbors{facetmp(combof(i,1))}=[neighbors{facetmp(combof(i,1))},...
            facetmp(combof(i,2:3))];
    end
end

for ipts=1:numpts
    neighbors{ipts}=unique(neighbors{ipts});
end

if sum(diag(edgesave))~=0
    warning('two same point for one face!');
end

if sum(edgesave(:)~=2 & edgesave(:)~=0)
    warning('wrong edge connection: ');
    badind=find(edgesave(:)~=2 & edgesave(:)~=0);
    for i=1:length(badind)
        [p1,p2]=ind2sub([numpts,numpts],badind(i));
        warning(['r:',num2str(p1),' c:',num2str(p2),...
            ' connection:',num2str(edgesave(p1,p2))]);
    end
end

% check for isolated points and under connected points
lnb=cellfun(@length,neighbors);
if sum(lnb<=2)
    warning('some points under connected');
    udcpts=find(lnb<=2);
    for ii=1:length(udcpts)
        i=udcpts(ii);
        warning(['point ',num2str(i),' number of neighbor: ',num2str(lnb(i))]);
    end
end

end

