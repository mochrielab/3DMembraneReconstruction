function [ nm ] = remove_badcontour( nm,iframe )
%remove bad contours

nuc=nm.nuclei;
cnt=nm.cnt_tmp;
cl=nm.celllength;
cw=nm.cellwidth;
co=nm.orientation;

img=nm.grab(iframe,nm.focusplane);
h=figure;
SI(img);
hold on;
for i=1:size(nuc,2)
    plot(nuc{iframe,i}.contour(round(nm.focusplane)).x+nuc{iframe,i}.origin(1),...
        nuc{iframe,i}.contour(round(nm.focusplane)).y+nuc{iframe,i}.origin(2));
end

title('left click to remove, right click to end');
exitg=1;
while exitg==1
    [ax,ay,exitg]=ginput(1);
    if exitg==1
        dist=(cnt(:,1)-ax).^2+(cnt(:,2)-ay).^2;
        min_dist=min(dist);
        cnt=cnt(dist~=min_dist,:);
        nuc=nuc(:,dist~=min_dist);
        cl=cl(dist~=min_dist);
        cw=cw(dist~=min_dist);
        co=co(dist~=min_dist);
        
        clf;
        SI(img);hold on;title('left click to remove, right click to end');
        for i=1:size(nuc,2)
            plot(nuc{iframe,i}.contour(round(nm.focusplane)).x+nuc{iframe,i}.origin(1),...
                nuc{iframe,i}.contour(round(nm.focusplane)).y+nuc{iframe,i}.origin(2));
        end
    end
end
close(h);

nm.cnt_tmp=cnt;
nm.num_nuc=size(nm.cnt_tmp,1);
nm.nuclei=nuc;
nm.celllength=cl;
nm.cellwidth=cw;
nm.orientation=co;

display([num2str(nm.num_nuc),' nuclei left.'])

end

