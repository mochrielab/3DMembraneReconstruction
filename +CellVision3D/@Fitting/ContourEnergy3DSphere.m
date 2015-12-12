
function [ energy,grad,intensity,dr ] = ContourEnergy3DSphere(ind,I,cost,rs0,edges,neighbors)
%calculate the total "energy" of the contour
%input: radius, at different angle
%       img, at different angle
%       cost, for length

% get intensity
ind_floor=floor(ind);
ind_d=ind-ind_floor;
ind1=sub2ind(size(I),ind_floor,(1:length(ind))');
ind2=sub2ind(size(I),ind_floor+1,(1:length(ind))');
intensity=I(ind1).*(1-ind_d)+I(ind2).*ind_d;


% dr pairs
edges_rind=ind(edges);
dr=edges_rind(:,1)-edges_rind(:,2);

% energy
energy=cost(1)*(dr'*dr)-sum(intensity);%+cost(2)*sum(dr1-3);

% gradient of the movie
neighbors(1:12,6)=(1:12)';

ndr=ind*ones(1,6)  - ind(neighbors);
grad=-(I(ind2)-I(ind1)) + 2*cost(1)*sum(ndr,2);%...


end


% %% second option
% 
% % fill five neighbor vertices to 6 neighbos
% neighbors(1:12,6)=(1:12)';
% meanInd=mean(ind(neighbors),2);
% dr=ind-meanInd;
% 
% % energy
% energy = cost(1)*(dr'*dr)-sum(intensity);
% 
% % gradient
% grad=-(I(ind2)-I(ind1)) + 2*cost(1)*(dr-1/6*sum(dr(neighbors),2));%...