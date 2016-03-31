function [ fmin,varargout ] = MinGaussian1D0B( P,x,y )
% calculate the fmin of 1D Gaussian function without background
% fmin= (y-gauss(x)).^2
% can minimize a vector of P at the same time
% size(P)=[n ,3]
% size(x)=[n ,r]
% 3/12/2015 Yao Zhao


%   P(3) peak height
%   P(1) peak position
%   P(2) peak width sigma

% 3/12/2015

[r,n]=size(x);
mu=ones(r,1)*P(1,:);
sigma=ones(r,1)*P(2,:);
amp=ones(r,1)*P(3,:);

if nargout==1
    fmin=sum(sum( (amp.*exp(-(x-mu).^2./(sigma.^2))-y).^2) );
elseif nargout ==2
    eterm = exp(-((x-mu)./sigma).^2);
    yet = amp.*eterm-y;
    yetet = eterm.*yet;
    df_da = sum(2* yetet,1);
    df_du = sum(4*amp./sigma.^2 .* yetet .* (x-mu),1);
    df_ds = sum(4*amp./sigma.^3 .* yetet .* (x-mu).^2,1);
    
    fmin = sum(sum(yetet.^2));
    varargout{1} = [df_du;df_ds;df_da];
end


% if nargout==1
%     fmin=sum((P(3)*exp(-(x-P(1)).^2/P(2)^2)-y).^2);
% elseif nargout ==2
%     a=P(3);
%     u=P(1);
%     s=P(2);
%
%     et = exp(-((x-u)/s).^2);
%     yet = y-a*et;
%     yetet = et.*yet;
%     df_da = sum(-2* yetet);
%     df_du = sum(4/s^2 * yetet .* (s-x));
%     df_ds = sum(-4*a/s^3 * yetet .* (s-x).^2);
%
%     fmin = sum(yetet.^2);
%     varargout{1} = [df_du,df_ds,df_da];
% end

end


