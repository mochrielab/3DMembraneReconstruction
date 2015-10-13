function [ d ] = get_par_center_dist(np,inuc)
%get particle to center dist
nuc=np.nuclei{1,inuc};
par=np.particle{1,inuc};
ncnt=nuc.center;
if par.isdouble==0
    pcnt=[par.particle1.x,par.particle1.y,par.particle1.z];
    d=norm(pcnt(1:2)-ncnt(1:2));
elseif par.isdouble==1
    pcnt=mean([par.particle2.x,par.particle2.y,par.particle2.z],1);
    d=norm(pcnt(1:2)-ncnt(1:2));
else
    d=nan;
end
end

