% make movies for show
% 3/20/2015

%% plot a simple tetrahedron
vertices=[1 0 -1/2;
    -1/2 sqrt(3)/2 -1/2;
    -1/2 -sqrt(3)/2  -1/2;
    0 0 1];
faces=[1 2 3;
    1 3 4;
    2 3 4;
    3 1 4;];
pat.vertices=vertices;
pat.faces=faces;
SP(pat,'none','k');hold on;
for i=1:size(vertices,1)
    pt=vertices(i,:);
    plot3(pt(1),pt(2),pt(3),'or');hold on;
    pt=vertices(i,:)+.1;
    text(pt(1),pt(2),pt(3),['[',num2str(pt,2.4),']'],'color','r');
end
axis off
%% 2d canny edge
savedir='media';
img=data(1).rawimage(:,:,6);
%   print(fullfile(savedir,'2draw'),gcf,'-dpng');
img1=bpass(img,.5,5);
%   print(fullfile(savedir,'2dfilt'),gcf,'-dpng');
bw=edge(img1,'canny',[.2 .4]);
%   print(fullfile(savedir,'2dcanny'),gcf,'-dpng');
se=strel('disk',3);
bw1=imfill(bw,'holes');
bw1=imerode(bw1,se);
bw1=edge(bw1);
SI(img,img1,bw,bw1);
%   print(fullfile(savedir,'2dcanny'),gcf,'-dpng');

%%


%
% raw movie
% load('data.mat');
savedir='media';
Vobj=VideoWriter(fullfile(savedir,'raw'),'MPEG-4');
Vobj.FrameRate=3;
Vobj.open;
for i=1:length(data)
    img=data(i).rawimage(:,:,6);
    imgproj=squeeze(sum(data(i).rawimage,3));
    clf
    SI(img);
    axis off;
    pause(.1);
    Vobj.writeVideo(getframe(gcf));
end
Vobj.close;



%%
% compare final
% load('data.mat');
savedir='media';
% Vobj=VideoWriter(fullfile(savedir,'compare'),'MPEG-4');
% Vobj.FrameRate=5;
% Vobj.open;
figure('Position',[0 50 1800 900]);
for i=1:length(data)
    %     img=data(i).rawimage(:,:,6);
    img=squeeze(sum(data(i).rawimage,3));
    clf
    axes('Unit','Pixels','Position',[0 0 900 900])
    img=img(:,end:-1:1);
    SI(img);
    axis off;
    axes('Unit','Pixels','Position',[900 0 900 900])
    pts=data(i).vertices;
    %     pat.vertices=[pts(:,1),-pts(:,2),pts(:,3)];
    %     axis([1 size(img,2) -size(img,1) -1  1 16*2.5]);
    pat.vertices=[pts(:,1)-5,pts(:,2)-5,pts(:,3)];
    axis([1 size(img,2) 1 size(img,1) 1 16*2.5]);
    pat.faces=data(i).faces;
    patch(pat,'FaceColor','r','EdgeColor','none');
    axis off;
    view(180,90);
    camlight;
    lighting gouraud;
    pause(.5);
%     Vobj.writeVideo(getframe(gcf));
end
% Vobj.close;
% 
%%
% detail plot
% load('data.mat');
savedir='media';
% Vobj.close;
% Vobj=VideoWriter(fullfile(savedir,'detail'),'MPEG-4');
% Vobj.FrameRate=5;
% Vobj.open;
figure('Position',[0 50 900 900]);
for ii=1:length(data)
    obj=data(ii);
    %initialize
    pts=obj.vertices;
    faces=obj.faces;
    edges=obj.edges;
    neighbors=obj.neighbors;
    numpts=size(pts,1);
    numfaces=size(faces,1);
    numedges=size(edges,1);
    imagesz=size(obj.image);
    zxr=obj.zxr;
    
    for istack=2:size(obj.image,3)
        
        clf
        % plot the cross section
        v=obj.image(:,:,1:istack);
        patch(isocaps(v*256,1),'FaceColor','interp','EdgeColor','none');hold on;
        colormap gray;
        
        % plot fit contour
        [allcontours,lowerfaces,lowerpts]=obj.GetCrossSection([0 0 1 istack*zxr]);
        for i=1:length(allcontours)
            c=allcontours{i};
            plot3(c(:,1),c(:,2),c(:,3)/zxr,'b');hold on;
        end
        
        %plot patch
        p.vertices=[lowerpts(:,1:2),lowerpts(:,3)/zxr];
        p.faces=lowerfaces;
        patch(p,'FaceColor','r','EdgeColor','none'); hold on;
        
        %         p4.vertices=[1 1 istack*zxr; 1 imagesz(1) istack*zxr; ...
        %             imagesz(2) imagesz(1) istack*zxr; imagesz(2) 1 istack*zxr];
        p4.vertices=[-200 -200 istack; -200 200 istack; ...
            200 200 istack; 200 -200 istack];
        p4.faces=[1 2 3 4];
        patch(p4,'FaceColor','y','FaceAlpha',.1);hold on;
        
        % plot properties
        lighting gouraud;
        camlight('headlight');
        view(50,30);
        axis([1 imagesz(1) 1 imagesz(2) 1 imagesz(3)]);
        daspect([1 1 1/1.8])
        axis off;
        pause(.01)
        %         Vobj.writeVideo(getframe(gcf));
    end
end
% Vobj.close;


%% get area
areas=nan(2,length(data));
for i=1:length(data)
    tmp=data(i).GetArea;
    areas(1:length(tmp),i)=tmp;
end
plot(1:length(data),areas(1,:),1:length(data),areas(2,:));

%% get volumes
vols=nan(2,length(data));
for i=1:length(data)
    data(i).GetVertexNormalDirection;
    tmp=data(i).GetVolume;
    vols(1:length(tmp),i)=tmp;
end
plot(1:length(data),vols(1,:),1:length(data),vols(2,:));


%%

% compare final
% load('data.mat');
savedir='media';
figure('Position',[0 50 900 900]);
zxr=data(1).zxr;
step=4;
for i=1:step:length(data)
    clf
    % mid slides
    if 1
        istack=round(mean(data(i).vertices(:,3)/zxr));
        img=data(i).rawimage(:,:,istack-5);
        %     img=data(i).image(:,:,istack);
        %         img=squeeze(sum(data(i).rawimage,3));
        clf
%         img=img(end:-1:1,:);
%         img=img(:,end:-1:1);
        SI(img);
        axis off;
        hold on;
        [allcontours,lowerfaces,lowerpts]=data(i).GetCrossSection([0 0 1 istack*zxr]);
        for ic=1:length(allcontours)
            c=allcontours{ic}-5;
%             c(:,2)=size(img,1)+1-c(:,2);
%             c(:,1)=size(img,2)+1-c(:,1);
%             c=c-5;
            plot(c(:,1),c(:,2),'r','LineWidth',2);hold on;
        end
        axis([11 70 1 60])
        title(['t=',num2str((i-1)*step*2.5),'s']);
        print(gcf,['mitotic_mid_',num2str(i)],'-dtiff')
    end
    pause(.2)
    %% whole
    clf
    if 1
        cropr=10;
        img=data(i).image;
        pts=data(i).vertices;
        %     pat.vertices=[pts(:,1),-pts(:,2),pts(:,3)];
        %     axis([1 size(img,2) -size(img,1) -1  1 16*2.5]);
        pat.vertices=[pts(:,1)-5,pts(:,2)-5,pts(:,3)];

        pat.faces=data(i).faces;
        patch(pat,'FaceColor','r','EdgeColor','none');
        axis image;
%         axis([1+cropr size(img,2)-cropr 1 size(img,1)-cropr-10 1 16*2.5]);
        axis([11 70 1 60 1 16*2.5])
        axis off;
        % xlabel('x')
        daspect=[1 1 1];
        view(0,-90);
%         view([0 0 1])
        camlight;
        lighting gouraud;
        title(['t=',num2str((i-1)*step*2.5),'s']);
        print(gcf,['mitotic_3d_',num2str(i)],'-dtiff')
    end
    pause(.2);
    %     Vobj.writeVideo(getframe(gcf));
end
% Vobj.close;

%% cross section
% detail plot
% load('data.mat');
savedir='media';
% Vobj.close;
% Vobj=VideoWriter(fullfile(savedir,'detail'),'MPEG-4');
% Vobj.FrameRate=5;
% Vobj.open;
figure('Position',[0 50 900 900]);
for ii=1:length(data)
    obj=data(ii);
    %initialize
    pts=obj.vertices;
    faces=obj.faces;
    edges=obj.edges;
    neighbors=obj.neighbors;
    numpts=size(pts,1);
    numfaces=size(faces,1);
    numedges=size(edges,1);
    imagesz=size(obj.image);
    zxr=obj.zxr;
    
    for istack=size(obj.image,3)/2%2:size(obj.image,3)
        
        clf
        %% 
        if 0
            % plot the cross section
            v=obj.image(:,:,1:istack);
            patch(isocaps(v*1000,1),'FaceColor','interp','EdgeColor','none');hold on;
            colormap gray;
            
            % plot fit contour
            [allcontours,lowerfaces,lowerpts]=obj.GetCrossSection([0 0 1 istack*zxr]);
            for i=1:length(allcontours)
                c=allcontours{i};
                plot3(c(:,1),c(:,2),c(:,3)/zxr,'b');hold on;
            end
            
            %plot patch
            p.vertices=[lowerpts(:,1:2),lowerpts(:,3)/zxr];
            p.faces=lowerfaces;
            patch(p,'FaceColor','r','EdgeColor','none'); hold on;
            
            %         p4.vertices=[1 1 istack*zxr; 1 imagesz(1) istack*zxr; ...
            %             imagesz(2) imagesz(1) istack*zxr; imagesz(2) 1 istack*zxr];
            p4.vertices=[-200 -200 istack; -200 200 istack; ...
                200 200 istack; 200 -200 istack];
            p4.faces=[1 2 3 4];
            patch(p4,'FaceColor','y','FaceAlpha',.1);hold on;
            
            % plot properties
            lighting gouraud;
            camlight('headlight');
            view(50,20);
            axis([1 imagesz(1) 1 imagesz(2) 1 imagesz(3)]);
            daspect([1 1 1/1.8])
            axis off;
        end
        
        pause(.01)
        %         Vobj.writeVideo(getframe(gcf));
    end
end

