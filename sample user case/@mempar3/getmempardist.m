function [ np ] = getmempardist(np)
%% calculate the distance from membrane to the particle
zxr=np.vox/np.pix*np.aberation;
points=np.points;
faces=np.faces;
for iframe=1;
    for inuc=1:np.num_nuc
        %%
        nuc=np.nuclei{iframe,inuc};
        % get double position
        particlepos_origin2=np.particle{iframe,inuc}.particle2;
        tmpx=particlepos_origin2.x;
        tmpy=particlepos_origin2.y;
        tmpz=particlepos_origin2.z;
        particle_seperation=sqrt((tmpx(2)-tmpx(1))^2+(tmpy(2)-tmpy(1))^2+((tmpz(2)-tmpz(1))*zxr)^2);
        particlepos_scaled2=[particlepos_origin2.x,particlepos_origin2.y,...
            particlepos_origin2.z]-[1;1]*nuc.origin;
        particlepos_scaled2(:,3)=particlepos_scaled2(:,3)*zxr;
        % get single postiion
        particlepos_origin1=np.particle{iframe,inuc}.particle1;
        particlepos_scaled1=(mean([particlepos_origin1.x,particlepos_origin1.y,...
            particlepos_origin1.z],1)-nuc.origin);
        particlepos_scaled1(3)=particlepos_scaled1(3)*zxr;
        % get membrane surface
        face_points=nuc.r*[1 1 1].*points;
        facedist1=get_facedist(face_points,faces,particlepos_scaled1);
        facedist2=get_facedist(face_points,faces,mean(particlepos_scaled2,1));
        facedist21=get_facedist(face_points,faces,particlepos_scaled2(1,:));
        facedist22=get_facedist(face_points,faces,particlepos_scaled2(2,:));
        %
        np.particle{iframe,inuc}.min_dist=[facedist1,facedist2,facedist21,facedist22];
        np.particle{iframe,inuc}.seperation=particle_seperation;
        np.particle{iframe,inuc}.isout=[facedist1,facedist2,facedist21,facedist22]<0;
        
        %         clf
        %         np.particle{1,inuc}
        %         nucleiplotsave(np,1,inuc);
        %
        %         pause
    end
end
end

function [minfacedist] = get_facedist(face_points,faces,particlepos_scaled)
facevol=zeros(1,size(faces,1));
facearea=zeros(1,size(faces,1));
facecenterdist=zeros(1,size(faces,1));
for iface=1:size(faces,1)
    face_points1=face_points(faces(iface,1),:);
    face_points2=face_points(faces(iface,2),:);
    face_points3=face_points(faces(iface,3),:);
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

