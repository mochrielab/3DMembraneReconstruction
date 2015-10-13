
function [ energy,grad,intensity,dr ] = contour_energy_3(ind,I,cost,rs0,edges,neighbors)
%calculate the total "energy" of the contour
%input: radius, at different angle
%       img, at different angle
%       cost, for length

% get intensity
ind_floor=floor(ind);
ind_d=ind-ind_floor;
ind1=sub2ind(size(I),ind_floor,1:length(ind));
ind2=sub2ind(size(I),ind_floor+1,1:length(ind));
intensity=I(ind1).*(1-ind_d)+I(ind2).*ind_d;

% dr pairs
edges_rind=ind(edges);
dr=edges_rind(:,1)-edges_rind(:,2);
dr1=abs(dr);
dr1(dr1<3)=0;
energy=cost(1)*(dr'*dr)-sum(intensity);%+cost(2)*sum(dr1-3);

% gradient of the movie
neighbors(1:12,6)=(1:12)';

% grad=-(I(ind2)-I(ind1)) + 2*cost*sum(ndr) + cost*10000*sum(ndr1);
ndr=ones(6,1)* ind - ind(neighbors)';
grad=-(I(ind2)-I(ind1)) + 2*cost(1)*sum(ndr);%...
  % +cost(2)*sum(ndr>3)-cost(2)*sum(ndr<3);

end
