function [ nm ,points2,faces2,psi,theta] = centralband_all( nm )
%interpolate and save centralband img for all the nuclei
%% setup image size
% num_points=64;
% angle_step=2*pi/num_points;
% psi1=(0:num_points-1)*angle_step;
% theta1=(-num_points/7:num_points/7)*angle_step;
% [psi,theta]=meshgrid(psi1,theta1);
% 
% %setup 3d angle for each pixel
% x=reshape(cos(psi).*cos(theta),numel(psi),1);
% y=reshape(sin(psi).*cos(theta),numel(psi),1);
% z=reshape(sin(theta),numel(psi),1);
% points2=[x,y,z];
% faces2=[];
% for i=2:size(psi,1)
%     for j=2:size(psi,2)
%         faces2=[faces2;sub2ind(size(psi),[i-1 i-1 i i],[j-1 j j j-1])];
%     end
% end
[ points2,faces2,psi,theta ] = setup_img(  );

% plot 3d
if 0
    p.vertices=points2;
    p.faces=faces2;
    patch(p,'FaceColor','r');
    view(3);
    daspect([1 1 1])
    grid off
    axis off
    camlight
    lighting gouraud
end
%% getting central band fitting
            warning('if movie is aberation corrected , dont correct again');

if ~isempty(nm)
    for inuc=1:nm.num_nuc
        for iframe=1:nm.endframe
            nuc=nm.nuclei{iframe,inuc};
%             nuc=centralband(nuc,nm,points2,size(psi),nm.aberation);
            nuc=centralband(nuc,nm,points2,size(psi),1);
            nm.nuclei{iframe,inuc}=nuc;
        end
    end
end

end

