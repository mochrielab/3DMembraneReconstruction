function[]=display_contour(nm)
%show all the contour

showplot=0;
points=nm.points;
faces=nm.faces;
zxr=nm.vox/nm.pix*nm.aberation;

% save nuclei selection to the folder
figure
SI(nm.grab(1,5));hold on;
title('nuclei selection at frame=1 z=5');axis off;
if ~isempty(nm.nuclei)
    cnt=[];
    for inuc=1:nm.num_nuc
        cnt(inuc,:)=nm.nuclei{1,inuc}.origin;
    end
    if ~isempty(cnt)
        plot(cnt(:,1),cnt(:,2),'or','Linewidth',2);
        plot(nm.cnt_tmp(:,1),nm.cnt_tmp(:,2),'.b');
    end
end

% for iframe=1:nm.numframes
%     figure(201)
%     clf
%     for inuc=1:nm.num_nuc
%         nuc=nm.nuclei{iframe,inuc};
%         center=[nuc.center(1:2),nuc.center(3)*zxr];
%         pts=[nuc.r.*points(:,1),nuc.r.*points(:,2),nuc.r.*points(:,3)]...
%             +ones(size(points,1),1)*center;
%         TR = triangulation(faces,pts);
%         trisurf(TR,'FaceColor','red','EdgeColor','black');hold on;
%         view(3);
%         axis([0 nm.sizeX 0 nm.sizeY 0 nm.sizeZ*zxr])
%         daspect([1 1 1])
%         grid off
%         camlight
%         lighting gouraud
%     end
%     pause(.1);
% end

%% plot volume over time
figure
points=nm.points;
faces=nm.faces;
volumes_all=zeros(nm.endframe,nm.num_nuc);
for iframe=1:nm.endframe
    clf
    for inuc=1:nm.num_nuc
        nuc=nm.nuclei{iframe,inuc};
        %         pts=(nuc.r*[1 1 1]).*points;
        %         nuc.volume=trisphere_volume(pts,faces);
        volumes_all(iframe,inuc)=nuc.volume;
        %         nm.nuclei{iframe,inuc}=nuc;
    end
end

plot((1:nm.endframe)',volumes_all);

%% plot energy map compare
%     if showplot
%         figure(102)
%         nuc=nm.nuclei{iframe,inuc};
%         intensity=nuc.intensity;
%         neighbors=nm.neighbors;
%         neighbors(1:12,6)=(1:12)';
%         r_energy=sum((indr(neighbors)-indr'*ones(1,6)).^2,2)*cost;
%         plot(1:length(intensity),intensity,1:length(intensity),r_energy)
%         legend('intensity','bending energy')
%     end
%% plot stack image
if showplot
    hw=(nm.wsize+1)/2;
    wsz=nm.wsize;
    f=figure(103);
    nuc=nm.nuclei{iframe,inuc};
    nuc_center=nuc.origin_new;
    set(f,'Position',[50 50 1500 600]);
    for i=1:10
        xi=nuc.contour(i).x;
        yi=nuc.contour(i).y;
        pr=floor((i-1)/5);
        pc=i-5*pr-1;
        pr=1-pr;
        axes('Unit','pixel','Position',[pc*300 pr*300 300 300]);
        %%%%% opts need to grab it   SI(wimg(:,:,i));
        hold on;
        plot(xi+hw+1,yi+hw+1,'-');
        axis off;
        box on;
        text(5,3,['Zstack:',num2str(i)],'Color','r','FontWeight','bold','FontSize',15);
        text(5,wsz-3,['Area:',num2str(nuc.contour(i).area)],'Color','y','FontWeight','bold','FontSize',15);
        if i==1
            text(5,10,[{'window center'},{['x:',num2str(nuc_center(1))]},...
                {['y:',num2str(nuc_center(2))]},{['z:',num2str(nuc_center(3))]}],...
                'Color','m','FontWeight','bold','FontSize',15);
            text(5,20,[{'nuc center'},{['x:',num2str(nuc.center(1))]},...
                {['y:',num2str(nuc.center(2))]},{['z:',num2str(nuc.center(3))]}],...
                'Color','g','FontWeight','bold','FontSize',15);
        end
    end
end
end

