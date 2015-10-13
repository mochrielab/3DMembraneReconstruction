function [  ] = ShowTrj(xyzt)
%plot trajectories of xyztid

if size(xyzt,2)==5
    dim=3;
elseif size(xyzt,2)==4
    dim=2;
else
    error('wrong dimenstion')
end

xyzt=sortrows(xyzt,dim+1);

num=xyzt(end,end);

for i=1:num
    xyz=xyzt(xyzt(:,end)==i,:);
    hold on;
    if dim==2
        plot(xyz(:,1),xyz(:,2),'.-');
    elseif dim==3
        plot3(xyz(:,1),xyz(:,2),xyz(:,3),'.-','Color',GenColor(i/num));axis equal;
    end
end


end

