function [ obj ] = labelPatch( obj )
%find and label the number of patch within the same object
% 3/18/2015
% add more codes to prevent special geometry

%%

%initialize
pts=obj.vertices;
faces=obj.faces;
numpts=size(pts,1);
numfaces=size(faces,1);

% patch id
ptsid=zeros(numpts,1);
facesid=zeros(numfaces,1);

% if points are on same faces
onsameface=zeros(numpts)+eye(numpts);
% loop through faces
for iface=1:numfaces
    p1=faces(iface,1);
    p2=faces(iface,2);
    p3=faces(iface,3);
    onsameface(p1,p2)=1;
    onsameface(p2,p1)=1;
    onsameface(p1,p3)=1;
    onsameface(p3,p1)=1;
    onsameface(p2,p3)=1;
    onsameface(p3,p2)=1;
end

patchid=0;
while sum(onsameface(:))>0
patchid=patchid+1;
% start a group
ptsgroup=find(diag(onsameface),1);
linked=find(sum(onsameface(ptsgroup,:),1));
% add all relavent groups
while length(ptsgroup)<length(linked)
    ptsgroup=linked;
    linked=find(sum(onsameface(ptsgroup,:),1));   
end
% removed calculated connections
onsameface(ptsgroup,ptsgroup)=0;
% set patch id for last group
ptsid(ptsgroup)=patchid;
end


%label faces
facesid=ptsid(faces(:,1));


%save
obj.ptspid=ptsid;
obj.facespid=facesid;
obj.numpatches=patchid;

end

