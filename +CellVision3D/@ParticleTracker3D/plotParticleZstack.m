function [  ] = plotParticleZstack( img,pk,p,th,zxr,showplot,varargin )
%show slice image of tracked data,
% pk, initial guess
% p, fit
% th, isosurface threshold
% 2014
% Yao Zhao

% % option to record movie
% if showplot>=1
%     daObj=VideoWriter(['stt3',num2str(showplot)]);
%     daObj.FrameRate=1;
%     open(daObj);
%     clf
% end

if length(varargin)>0
    parent=varargin{1};
else
    parent=figure;
end

cros=[1 0 0; -1 0 0 ; 0 0 0 ; 0 1 0; 0 -1 0; 0 0 0; 0 0 1;0 0 -1]*2;
th=th*max(img(:));
for istack=2:size(img,3)
    delete(get(parent,'Children'));
    axes('Parent',parent,'Unit','Normalized','Position',[0 0 1/2 1])
    % plot in that stack
    pksec=pk((pk(:,3))==istack,[1,2]);
    if istack==1
        pksec2=p(round(p(:,3))==0|round(p(:,3))==1,[1,2,4]);
    elseif istack==size(img,3)
        pksec2=p(round(p(:,3))==size(img,3)|round(p(:,3))==size(img,3)+1,[1,2,4]);
    else
        pksec2=p(round(p(:,3))==istack,[1,2,4]);
    end
    imagesc(squeeze(img(:,:,istack)),[min(img(:)),max(img(:))]);axis image;colormap gray;
    title(num2str(istack))
    hold on;
    plot(pksec(:,1),pksec(:,2),'.b');
    plot(pksec2(:,1),pksec2(:,2),'ro');
    
    % isosurface plot
    axes('Parent',parent,'Unit','Normalized','Position',[1/2 0 1/2 1])
    pks=p(p(:,3)<=istack,:);
    v=img(:,:,1:istack);
    pat=patch(isosurface(v,th),'FaceColor','red','EdgeColor','none');
    pat2=patch(isocaps(v,th),'FaceColor','interp','EdgeColor','none');
    colormap gray;
    isonormals(v,pat);
    daspect([1,1,1/zxr])
    view([1 1 1]);
    axis([0 size(img,2)+1 0 size(img,1)+1 0 size(img,3)+2])
    camlight
    lighting gouraud
    hold on;
    for j=1:size(pks,1)
        plot3(pks(j,1)+cros(:,1)*pks(j,4),pks(j,2)+cros(:,2)*pks(j,4),...
            pks(j,3)+cros(:,3)*pks(j,4)/zxr,'b','LineWidth',5)
    end
%     subplot(2,2,3)
%     set(gca,'nextplot','replacechildren');
%     set(gcf,'Renderer','zbuffer');
    if showplot<1
        pause(showplot)
%     else pause(1)
%         writeVideo(daObj,getframe(gcf));
    end
    
end
% if showplot>=1
%     close(daObj);
% end

end

