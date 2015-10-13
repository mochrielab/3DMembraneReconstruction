function [ d, directionsign] = distance2shape( obj, pos )
%calculate the distance between the shape and the particle
pts=obj.vertices;
faces=obj.faces;

% get points with shortest distance to surface
ptsdist=sqrt(sum((pts-(ones(size(pts,1),1)*pos)).^2,2));
[mindist1,ptsind]=min(ptsdist);

% get face connected to that vertices
chooseface = faces(:,1)==ptsind | faces(:,2)==ptsind | faces(:,3)==ptsind;
faces=faces(chooseface,:);

facevol=zeros(1,size(faces,1));
facearea=zeros(1,size(faces,1));
facenorm=zeros(size(faces,1),3);
face_point_in=false(1,size(faces,1));
facecenterdist=zeros(1,size(faces,1));
fnsum=0;
for iface=1:size(faces,1)
    % face points
    p1=pts(faces(iface,1),:);
    p2=pts(faces(iface,2),:);
    p3=pts(faces(iface,3),:);
    face_center=(p1+p2+p3)/3;
    % face volume , face area
    edge12=p1-p2;
    edge32=p3-p2;
    vecp2=pos-face_center;
    facevol(iface)=-1/6*vecp2*cross(edge12,edge32)';
    facecenterdist(iface)=norm(pos-face_center);
    facearea(iface)=1/2*norm(cross(edge12,edge32));
    % decide if it project to surface
    fn=(cross(edge12,edge32));
    fn=fn/norm(fn);
    facenorm(iface,:)=fn;
    n1=edge12/norm(edge12);
    n2=cross(fn,n1);
    pp1=[p1*n1',p1*n2'];
    pp2=[p2*n1',p2*n2'];
    pp3=[p3*n1',p3*n2'];
    pp0=[pos*n1',pos*n2'];
    n1s=[pp1(1),pp2(1),pp3(1),pp1(1)];
    n2s=[pp1(2),pp2(2),pp3(2),pp1(2)];
    face_point_in(iface)=inpolygon(pp0(1),pp0(2),n1s,n2s);
    % vertice normal
    fnsum=fnsum+fn;
end
fnsum=fnsum/size(faces,1);
facedist=3*facevol./facearea;
facedistabs=abs(facedist);
[mindist2,faceind]=min([facedistabs(face_point_in),inf]);


if mindist1<mindist2
    d=mindist1;
    directionsign = 2*((pos-pts(ptsind,:))*fnsum'>0)-1;
else
    d=mindist2;
    directionsign = 2*((pos-pts(ptsind,:))*facenorm(faceind,:)'>0)-1;
end
% obj.PlotMeshSim;hold on; plot3(pos(1),pos(2),pos(3),'o');

end

