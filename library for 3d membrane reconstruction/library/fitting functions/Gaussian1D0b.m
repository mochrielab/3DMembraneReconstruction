function [ f ] = Gaussian1D0b( P,x )
%1D Gaussian function with out background
%   P(4) background
%   P(3) peak height
%   P(1) peak position
%   P(2) peak width sigma



% if nargout==1
    f=P(3)*exp(-(x-P(1)).^2/P(2)^2);
% elseif nargout ==2
%     a=P(3);
%     u=P(1);
%     s=P(2);
% %     f=a*exp(-(x-u).^2/s^2);
%     
%     
% end

end

