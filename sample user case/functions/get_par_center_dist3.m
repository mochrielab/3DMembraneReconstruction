function [ d ] = get_par_center_dist3(np,inuc)
%get particle to center dist
nuc=np.nuclei{1,inuc};
par=np.particle{1,inuc};
ncnt=nuc.center;
if par.isdouble==0
    pcnt=[par.particle1.x,par.particle1.y,par.particle1.z];
    d=(pcnt(1:3)-ncnt(1:3));
    d(3)=d(3)*np.zxr;
    d=norm(d);
elseif par.isdouble==1
    pcnt=mean([par.particle2.x,par.particle2.y,par.particle2.z],1);
    d=(pcnt(1:3)-ncnt(1:3));
    d(3)=d(3)*np.zxr;
    d=norm(d);else
    d=nan;
end
end

