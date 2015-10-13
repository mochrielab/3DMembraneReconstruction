function [ trjnew ] = MergeProperties( trj,pos,dim )
%mergy tracked trajectories with other properies from original position
%output format trjnew= x y (z) t props... id
if size(trj,1)~=size(pos,1)
    warning('not equal length of trj and pos')
end
err=0.000001;
trjnew=zeros(size(trj,1),size(pos,2)+1);

if dim==2
    for i=1:size(trj,1)
        for j=1:size(pos,1)
            if trj(i,3)==pos(j,3) && sum((trj(i,1:2)-pos(j,1:2)).^2)<err
                trjnew(i,:)=[trj(i,1:3),pos(j,4:end),trj(i,4)];
            end
        end
    end
elseif dim==3
     for i=1:size(trj,1)
        for j=1:size(pos,1)
            if trj(i,4)==pos(j,4) && sum((trj(i,1:3)-pos(j,1:3)).^2)<err
                trjnew(i,:)=[trj(i,1:4),pos(j,5:end),trj(i,5)];
            end
        end
    end
else
    error('dim wrong value');
end


end

