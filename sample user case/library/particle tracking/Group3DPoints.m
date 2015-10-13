function [pairs,pairs2] = Group3DPoints(p,d,zxr)
% Group3DPoints( p, d )
pos=p;
gn=0;
pairs2=[];
tmppair=[];
while ~isempty(pos)
    %creat new group
    if isempty(tmppair)
        tmppair=pos(1,:);
        pos=pos(2:end,:);
        gn=gn+1;
        pointer=1;
    end
    addpair=[];
    addind=ones(size(pos,1),1);
    %move check linked in pos
    for i=1:size(pos,1)
        if isempty(zxr)
            if (pos(i,1)-tmppair(pointer,1))^2+(pos(i,2)-tmppair(pointer,2))^2 <d^2;                addpair=[addpair;pos(i,:)];
                addind(i)=0;
            end
        else
            if (pos(i,1)-tmppair(pointer,1))^2+(pos(i,2)-tmppair(pointer,2))^2 ...
                    +(pos(i,3)-tmppair(pointer,3))^2*zxr^2<d^2;
                addpair=[addpair;pos(i,:)];
                addind(i)=0;
            end
        end
    end
    %move pos to pairs
    tmppair=[tmppair;addpair];
    pos=pos(find(addind),:);
    %check if searched all
    if pointer == size(tmppair,1)
        pairs{gn}=tmppair;
        pairs2=[pairs2;tmppair,zeros(size(tmppair,1),1)+gn];
        tmppair=[];
    else
        pointer=pointer+1;
    end
end
pairs=pairs';
end

