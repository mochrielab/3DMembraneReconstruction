function [ f ] = Gaussian1D0b( P,x )
%1D Gaussian function with out background
%   P(4) background
%   P(3) peak height
%   P(1) peak position
%   P(2) peak width sigma



if size(P,1)==1 || size(P,2)==1
    f=P(3)*exp(-(x-P(1)).^2/P(2)^2);
else 
    f=0;
    for i=1:size(P,1)
        f=f+P(i,3)*exp(-(x-P(i,1)).^2/P(i,2)^2);
    end
end
%     a=P(3);
%     u=P(1);
%     s=P(2);
% %     f=a*exp(-(x-u).^2/s^2);
%     
%     
% end

end

