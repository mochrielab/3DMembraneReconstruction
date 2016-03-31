function [ se ] = strel( type, varargin)
% construct 3d kernal for morphological op
% input format: type first
%               disk type, half size, zxr
%               no other type supported



if strcmp(type,'disk')
    hw=5;
    zxr=1;
    if nargin>=2
        hw=varargin{1};
    end
    if nargin>=3
        zxr=varargin{2};
    end
    hwz=ceil(hw/zxr);
    se=zeros(hw*2+1,hw*2+1,2*hwz+1);
    [x, y, z]=meshgrid(-hw:hw,-hw:hw,-hwz:hwz);
    r=sqrt(x.^2+y.^2+z.^2*zxr^2);
    se(r<=hw)=1;
else
    se=[];
    warning('wrong type');
end

end

