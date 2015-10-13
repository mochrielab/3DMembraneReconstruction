function [ area ] = sphere_area(P,z)
%calculate the crossection area give spherical height
%input: P(1): radius of sphere
%       P(2): center of sphere
%       z: vector of heigh position
R=P(1);
z0=P(2);
% z_shrink_factor=1.33/1.516;%P(3);
in_bound=abs(z-z0)<=R;
area=zeros(size(z));
area(in_bound)=pi*(R^2-((z0-z(in_bound)).^2));%*z_shrink_factor^2);
end

