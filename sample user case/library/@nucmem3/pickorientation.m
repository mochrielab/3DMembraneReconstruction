function nm=pickorientation(nm)
iframe=1;
img=nm.proj(iframe);
wsize=50;

x=zeros(nm.num_nuc,4);
y=zeros(nm.num_nuc,4);

for inuc=1:size(nm.cnt_tmp,1)
%     nuc=nm.nuclei{iframe,inuc};
    %         cnt=round(nuc.origin_new);
    cnt=nm.cnt_tmp(inuc,:);
    wimg0=WindowImageUS(cnt(1),cnt(2),wsize,img);
    clf
    SI(wimg0);hold on;
    for ichoose=1:4
        if ichoose<=2
            title('choose long axis');
        else
            title('choose short axis')
        end
        [x(inuc,ichoose),y(inuc,ichoose)]=ginput(1);
        plot(x(inuc,ichoose),y(inuc,ichoose),'ro');
        text(x(inuc,ichoose)+2,y(inuc,ichoose)+2,num2str(ichoose),...
            'color','r');
    end
    
end

orientation=(atan((y(:,2)-y(:,1))./(x(:,2)-x(:,1))))*180/pi;
celllength=sqrt((y(:,2)-y(:,1)).^2+(x(:,2)-x(:,1)).^2);
cellwidth=sqrt((y(:,4)-y(:,3)).^2+(x(:,4)-x(:,3)).^2);

nm.orientation=orientation;
nm.celllength=celllength;
nm.cellwidth=cellwidth;
nm.cpts4.x=x;
nm.cpts4.y=y;

end