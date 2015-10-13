function  nm=add_goodcentroid(nm)
%add good centroid based on first frame
iframe=1;
cnt=nm.cnt_tmp;
img=nm.grab(iframe,nm.focusplane);
h=figure;
SI(img);
hold on;
DrawCircles(cnt(:,1:2),1,'r',10);
title('left click to remove, right click to end');
exitg=1;
while exitg==1
    [ax,ay,exitg]=ginput(1);
    if exitg==1
        dist=(cnt(:,1)-ax).^2+(cnt(:,2)-ay).^2;
        min_dist=min(dist);
        cnt=cnt(dist~=min_dist,:);
        clf;
        SI(img);hold on;title('left click to remove, right click to end');
        DrawCircles(cnt(:,1:2),5,'r',10);
    end
end
close(h);
nm.cnt_tmp=cnt;
nm.num_nuc=size(nm.cnt_tmp,1);
display([num2str(nm.num_nuc),' nuclei left.'])
end

