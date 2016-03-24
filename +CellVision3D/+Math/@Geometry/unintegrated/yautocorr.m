function [ y ] = yautocorr( x, varargin )
% calculate the autocorrelation of p
% support mulitple channels in columns
% input: matrix x, number of frames (optional)
% 10/15/2015
% Yao Zhao

if nargin == 1
    num=size(x,1);
elseif nargin ==2
    num=varargin{1};
end

y=zeros(num,1);
for i=0:num-1
    x1=x(1:end-i,:);
    x2=x(1+i:end,:);
    y(i+1)=sum(diag(x1*x2'))/sqrt(sum(sum(x1.^2))*sum(sum(x2.^2)));
end

end

