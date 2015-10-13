function [ c ] = GenColor( i , varargin)
%generate color code for plot based on input 0-1

if nargin==1
    c=[cos(pi*i/2).^2 cos(pi*i/2-pi/4).^2 cos(pi*i/2-pi/2).^2];
elseif nargin==2
    num= floor(varargin{1}^(1/3))+1;
    i1=round(i*num^3);
    ir=mod(i1,num);
    ig= mod((i1-ir)/num,num);
    ib= (i1-ig*num-ir)/num^2;
    c(:,:,1)=ir/num;
    c(:,:,2)=ig/num;
    c(:,:,3)=ib/num;
else
    error('wrong number of input')
end


end

