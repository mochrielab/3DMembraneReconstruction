function [ np ] = nucleiplotsave( np,iframe,inuc )
%% plot and save each nuclei image
zxr=np.vox/np.pix*np.aberation;
nuclei=np.nuclei{iframe,inuc};
if np.particle{iframe,inuc}.isdouble
    particletmp=np.particle{iframe,inuc}.particle2;
else
    particletmp=np.particle{iframe,inuc}.particle1;
end
particle=[particletmp.x,particletmp.y,particletmp.z,particletmp.sigxy,particletmp.sigz];
particle(:,1:2)=particle(:,1:2)-ones(size(particle,1),1)*nuclei.origin(1:2);
particle(:,3)=(particle(:,3)-nuclei.origin(:,3))*zxr;
p.vertices=np.points.*(nuclei.r*[1 1 1]);
p.faces=np.faces;

for j=1:size(particle,1)
    [x, y, z] = ellipsoid(particle(j,1),particle(j,2),particle(j,3),...
        particle(j,4)/2,particle(j,4)/2,particle(j,5)/2,30);
    h=surfl(x, y, z);
    set(h,'EdgeColor','none','FaceColor','k');
    colormap(gray);
    hold on;
end
% plot3(mean(particle(:,1)),mean(particle(:,2)),mean(particle(:,3)),'ob')

% shading interp

patch(p,'FaceColor','r','EdgeColor','none','FaceAlpha',0.3);
axis image;axis off;
camlight
lighting gouraud
view([1 0 0]);

end

