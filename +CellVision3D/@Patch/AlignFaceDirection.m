function [ obj ] = alignFaceDirection( obj )
%adjust face directions to facing same direction
% 3/14/2015 Yao Zhao


pts=obj.vertices;
numpts=size(pts,1);

facesfinal=[];
obj.labelPatch;
for ipatch=1:obj.numpatches
% sort faces in rising order
facesptmp=sort(obj.faces(obj.facespid==ipatch,:),2);
% creat edge count and initialize
edgesave=zeros(numpts,numpts);
facetmp=facesptmp(1,:);
% +1 means from 1 to 2, -1 means from 2 to 1
edgesave(facetmp(1),facetmp(2))=1;
edgesave(facetmp(2),facetmp(3))=1;
edgesave(facetmp(1),facetmp(3))=-1;
% find first single edge
first_single_edge=find(edgesave,1);
% update face
facesnew=facetmp;
facesleft=facesptmp(2:end,:);
% continue if edge is single
while ~isempty(first_single_edge)
    % get point index of the defined edge
    [p1, p2]=ind2sub(size(edgesave),first_single_edge);
    searchmat=[1 2 3; 2 3 1; 1 3 2];
    % find the faces in the leftover pool that contain this edge
    for isearch=1:3
        searchtmp=searchmat(isearch,:);
        indtmp=find(facesleft(:,searchtmp(1))==p1 & facesleft(:,searchtmp(2))==p2,1);
        % didnt find in this combination
        if isempty(indtmp)
            continue;
        % found the new faces to add
        else
            % direction of the previous edge
            dirpre=edgesave(p1,p2);
            p3=facesleft(indtmp,searchtmp(3));
            if dirpre==1
                % create new face with right order
                facetmp=[p2,p1,p3];
                % add new edges
                edgesave(p1,p2)=edgesave(p1,p2)-1;
                ptstmp=sort([p1,p3]);
                edgesave(ptstmp(1),ptstmp(2))=edgesave(ptstmp(1),ptstmp(2))+(p1<p3)*2-1;
                ptstmp=sort([p3,p2]);
                edgesave(ptstmp(1),ptstmp(2))=edgesave(ptstmp(1),ptstmp(2))+(p3<p2)*2-1;
            elseif dirpre==-1
                 % create new face with right order
                facetmp=[p1,p2,p3];
                % add new edges
                edgesave(p1,p2)=edgesave(p1,p2)+1;
                ptstmp=sort([p2,p3]);
                edgesave(ptstmp(1),ptstmp(2))=edgesave(ptstmp(1),ptstmp(2))+(p2<p3)*2-1;
                ptstmp=sort([p3,p1]);
                edgesave(ptstmp(1),ptstmp(2))=edgesave(ptstmp(1),ptstmp(2))+(p3<p1)*2-1;

            end
            break;
        end
    end
    % save face
    if ~isempty(facetmp);
    facesnew=[facesnew;facetmp];
    facesleft=[facesleft(1:indtmp-1,:);facesleft(indtmp+1:end,:)];
    else
        error('couldnt find matching face');
    end
    % get new edge to start with
    first_single_edge=find(edgesave,1);
end
facesfinal=[facesfinal;facesnew];
end
%%
obj.faces=facesfinal;
obj=calculateEdgesAndNeighbors( obj );



end

