function [ posnew,nx,ny,nz ] = rotate3dto( new_axis_x,new_axis_y,pos )
% rotate the points to a new axis system
% new_axis_x and new_axis_y are the new axis normal direction in the old coordinate
% system. pos are points in the old coordinate system
% 2015
% Yao Zhao

if size(pos,2)~=3 || length(new_axis_x)~=3 || length(new_axis_y)~=3
    error('wrong size of input variables');
end


% get axis of the new matrix
nx=reshape(new_axis_x,3,1)/norm(new_axis_x);
ny=reshape(new_axis_y,3,1)/norm(new_axis_y);
if (nx'*ny)>1e-31
    error('x y axis not perpendicular');
end
nz=cross(nx,ny);

% project to new axis

numpos=size(pos,1);
posnew=zeros(numpos,3);
posnew(:,1)=sum(pos.*(ones(numpos,1)*nx'),2);
posnew(:,2)=sum(pos.*(ones(numpos,1)*ny'),2);
posnew(:,3)=sum(pos.*(ones(numpos,1)*nz'),2);
% i=1

end

