function [ obj ] = ShowParticleTracks( obj, varargin )
%show particle tracks of each cell

%%
% loop through each cell
colors=hsv(obj.numchannels+2);
for icell=1:obj.numdata
    clf;
    % get cell contour
    contour=obj.data(icell).contour;
    [xc, yc, z2] = ellipsoid(0,0,0,contour.length/2,contour.width/2,contour.width/2);
    theta=contour.theta;
    xcr=xc*cos(theta)+yc*sin(theta);
    ycr=yc*cos(theta)-xc*sin(theta);
    % plot cell contour
    h1=surfl(xcr, ycr, z2);
    set(h1,'EdgeColor','none','FaceColor',colors(obj.numchannels+1,:),'FaceAlpha',0.1);
    hold on;
    camlight
    lighting gouraud
    axis equal;
    % plot nuclei contour
    [xn, yn, zn] = ellipsoid(0,0,0,.9*contour.width/2,.9*contour.width/2,.9*contour.width/2);
    h2=surfl(xn, yn, zn);
    set(h2,'EdgeColor','none','FaceColor',colors(obj.numchannels+2,:),'FaceAlpha',0.1);
    
    hold on;
    for ichannel=1:obj.numchannels
        %%
        channelname=obj.channelnames{ichannel};
        nump=obj.data(icell).(channelname).numpeaks;
        % only works for single particle at the moment
        pos=[obj.data(icell).(channelname).particle.value,];
        for ip=1:nump
            pos2=reshape(pos(ip,:),5,length(pos)/5)';
            pos2(:,1:3)=pos2(:,1:3)-obj.drift;
            % plot particle tracks
            plot3(pos2(:,1)-contour.center(1),...
                pos2(:,2)-contour.center(2),...
                (pos2(:,3)-contour.focalplane)*obj.zxr,...
                'color',colors(ichannel,:),...
                'linewidth',3);
            hold on;
        end
    end
    legend([{'cell'},{'nuclei'},obj.channelnames']);
%     FigureFormat(gcf);
    pause
end

end




