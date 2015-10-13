function [ sep ] = getpar2sep( np,inuc )
%
par2=np.particle{1,inuc}.particle2;

sep=sqrt(diff(par2.x)^2+diff(par2.y)^2+diff(par2.z)^2);

end

