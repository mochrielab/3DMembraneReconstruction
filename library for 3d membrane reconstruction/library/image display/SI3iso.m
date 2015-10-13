function [] = SI3iso( img,p,zxr,ip)
%show the image with multiple threshold and tracked point

%     daObj=VideoWriter(['si3',num2str(ip)],'MPEG-4');
%     daObj.FrameRate=1;
%     open(daObj);
%     clf
n=6;
c=jet(n);
% c=flipud(c);
th=(linspace(0.1,0.9,n).^2)*max(img(:));
hold on;

for j=1:size(p,1)
[x, y, z] = ellipsoid(p(j,1),p(j,2),p(j,3),p(j,4)/2,p(j,4)/2,p(j,4)/2+1,30); 
surfl(x, y, z)
% shading interp
colormap(gray);
axis equal;
end

for i=1:n
    pat=patch(reducepatch(isosurface(img,th(i)),.3),'FaceColor','none',...
        'EdgeColor',sqrt(c(i,:)),'EdgeAlpha',(i/n)^2);
    isonormals(img,pat);
    daspect([1,1,1/zxr])
end
    axis([0 size(img,2)+1 0 size(img,1)+1 0 size(img,3)+2])
    axis image
    axis off
    camlight 
    lighting gouraud
    view(3);
    saveas(gcf,['si3',num2str(ip),'.png'])
% nFrames=20;
% angles=linspace(0,360,nFrames);
% mfi=[];
% mov(1:nFrames) = struct('cdata', [],'colormap', []);
% daObj=VideoWriter('m1.avi','MPEG-4');
% daObj.FrameRate=1;
% open(daObj);
% for i=1:length(angles)
%     view(angles(i),30); %     drawnow;
% %     print(gcf, '-djpeg100', '-r100', sprintf('image_%d', i));
% %     i
% %     print(gcf, '-djpeg100', '-r100', 'imagetmp');
% %     [mfi(:,:,:,i),map]=imread('imagetmp.jpg');
% %     writeVideo(daObj,getframe(gcf));
% 
% %                 set(gca,'nextplot','replacechildren');
% %                 set(gcf,'Renderer','zbuffer');
% %                 pause(.5)
% %                 writeVideo(daObj,getframe(gcf));
% end  
% mov=immovie(mfi,map);
% close(daObj);
% movie2avi(mov, 'm1.avi','fps',5, 'compression', 'None');

end

