%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% z = Gaussian2D(p,x,y)
% 
% Summary:
%     This function calculates a 2D gaussian function with parameters set in
%     p and x and y coordinates
%     
% Input:
%     p - a vector of the means and sigmas and amplitude
%     x - x coordinate
%     y - y coordinate
%     
% Output:
%     z = 2D gaussian value
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function z = Gaussian2D(p,x,y)

mux = p(1);
muy = p(2);
sigma= p(3);
A = p(4);
C = p(5);

z = A*exp(-0.5*(x-mux).^2./(sigma^2)-0.5*(y-muy).^2./(sigma^2)) + C;