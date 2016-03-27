function [ d ] = getPointSurfaceDistance( points, vertices, faces, varargin )
% get the shortest dinstance from a set of points to the surface
% 3/26/2016 Yao Zhao


% get the z to x ratio from the input
if length(varargin)<1
    zxr=1;
else
    zxr=varargin{1};
end

% face point scaled to zxr coordiantes
face_point_scaled = vertices.*(ones(size(vertices,1),1)*[1 1 zxr]);

% number of input particles
numparticles=size(points,1); 

% distance
d=zeros(numparticles,1);

% scale particle position and surface position
for iparticle=1:numparticles
    d(iparticle)=get_facedist(face_point_scaled,faces,points(iparticle,1:3).*[1 1 zxr]);
end


end

function [minfacedist] = get_facedist(face_points_scaled,faces,particlepos_scaled)
facevol=zeros(1,size(faces,1));
facearea=zeros(1,size(faces,1));
facecenterdist=zeros(1,size(faces,1));
for iface=1:size(faces,1)
    face_points1=face_points_scaled(faces(iface,1),:);
    face_points2=face_points_scaled(faces(iface,2),:);
    face_points3=face_points_scaled(faces(iface,3),:);
    face_center=(face_points1+face_points2+face_points3)/3;
    
    edge12=face_points1-face_points2;
    edge32=face_points3-face_points2;
    vecp2=particlepos_scaled-face_center;
    facevol(iface)=-1/6*vecp2*cross(edge12,edge32)';
    facecenterdist(iface)=norm(particlepos_scaled-face_center);
    facearea(iface)=1/2*norm(cross(edge12,edge32));
end
facedist=3*facevol./facearea;
[~,min_index]=min(facecenterdist);
minfacedist=facedist(min_index);
end
