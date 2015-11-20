function [ output ] = Gaussian1D( P,x )
%Gaussian function
%   P(4) background
%   P(3) peak height
%   P(1) peak position
%   P(2) peak width sigma

output=P(3)*exp(-(x-P(1)).^2/P(2)^2)+P(4);

end

