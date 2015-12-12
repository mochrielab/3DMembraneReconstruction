function [ allcontours,lowerfaces,pts] = getCrossSection( pts,faces,v )
%get cross section of the patch
% input: vertices, vertices of the patch
%       faces, faces of the patch
%       face vector: v=[nx,ny,nz,c] nx*x+ny*y+nz*z=c
% output: allcontours
%         lowerfaces
%         pts
% Yao Zhao 12/11/2015
% there is a known bug that occurs when a plane of vertices perfectly
% intersect with the intersection plane, will fix it later, one of the
% greater/lesser sign should add equal sign to it

%%

%initialize
numfaces=size(faces,1);
faces=[faces,nan(numfaces,1)];

% direction vector
n=v(1:3)/norm(v(1:3));
% interseption
c=v(4);

% calculate the line that faces intersect with plane
linesection=[];
facechoose=false(numfaces,1);
for iface=1:numfaces
    % calculate distance to the plane from 3 vertices and sort them
    faceind=faces(iface,1:3);
    pmat=pts(faceind',:);
    [planedist,sortind] = sort( pmat*n'-c);
    % decide if triangle intersect or not
    % intersect if distance 1 and 3 have different sign
    if planedist(3)>=0 && planedist(1)<=0
        p1=pts(faceind(sortind(1)),:);
        p2=pts(faceind(sortind(2)),:);
        p3=pts(faceind(sortind(3)),:);
        faceind=faceind(sortind(1:3));
        % two cases for the vertices 2
        if planedist(2)>=0
            y1=crosspoint(p1,p2,n,c);
            y2=crosspoint(p1,p3,n,c);
            ind = [faceind(1) faceind(2) faceind(1) faceind(3)];
            pts=[pts;y1;y2];
            ind1=size(pts,1)-1;
            ind2=size(pts,1);
            faces(iface,:)=[faceind(1),ind1,ind2,NaN];
        else
            y1=crosspoint(p1,p3,n,c);
            y2=crosspoint(p2,p3,n,c);
            ind = [faceind(1) faceind(3) faceind(2) faceind(3)];
            pts=[pts;y1;y2];
            ind1=size(pts,1)-1;
            ind2=size(pts,1);
            faces(iface,:)=[faceind(1),ind1,ind2,faceind(2)];
        end
        linesection=[linesection;y1,y2,ind];
    end
    if planedist(1)<=0
        facechoose(iface)=1;
    end
end
lowerfaces=faces(facechoose,:);

% connect all lines together
% lines remain
lineleft=linesection;
% lines new
linenew=[];
% all contours
allcontours=[];
while ~isempty(lineleft)
    % if new line is eimpty, start a line
    if isempty(linenew)
        linenew=[lineleft(1,[1:3,7:10]);lineleft(1,[4:6,7:10])];
        lineleft=lineleft(2:end,:);
    else
        lastpoint=linenew(end,1:3);
        numleft=size(lineleft,1);
%         l1=find(sum((lineleft(:,1:3)-ones(numleft,1)*lastpoint).^2,2)<1e-20);
%         l2=find(sum((lineleft(:,4:6)-ones(numleft,1)*lastpoint).^2,2)<1e-20);
        l1=find(sum((lineleft(:,1:3)-ones(numleft,1)*lastpoint).^2,2)==0);
        l2=find(sum((lineleft(:,4:6)-ones(numleft,1)*lastpoint).^2,2)==0);
        if ~isempty(l1)
            linenew=[linenew;lineleft(l1,[4:6,7:10])];
            lineleft=lineleft((1:numleft)~=l1,:);
        elseif ~isempty(l2)
            linenew=[linenew;lineleft(l2,[1:3,7:10])];
            lineleft=lineleft((1:numleft)~=l2,:);
        else
            allcontours=[allcontours,{[linenew;linenew(1,:)]}];
            linenew=[];
        end
    end
end
if ~isempty(linenew)
allcontours=[allcontours,{[linenew;linenew(1,:)]}];
end

% % plot
% for i=1:length(allcontours)
%     c=allcontours{i};
%     plot3(c(:,1),c(:,2),c(:,3));hold on;
% end

end

function y = crosspoint(p1,p2,n,c)
    l=p2-p1;
    ln= (l*n');
%     lp=l-ln;
    r= (c-p1*n')/ln;
    y=p1+l*r;
end