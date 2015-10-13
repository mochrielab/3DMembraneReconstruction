function [ zcnt ] = z_off_abs( np,inuc )
% calculate the center off Z off

particle=np.particle{1,inuc};
nuc=np.nuclei{1,inuc};
if particle.isdouble
    zcnt=abs(mean(particle.particle2.z)-nuc.origin(3));
else
    zcnt=abs(particle.particle1.z-nuc.origin(3));
end


end

