function [ obj ] = ShowCellSelection( obj, varargin )
%show selection of cell

% color
colors=hsv(obj.numchannels+2);
% draw image
bf_channel_id = find(strcmp(obj.channeltypes,'bf'));
if length(bf_channel_id)==1
    SI(obj.GrabProjection(bf_channel_id,1)); hold on;
elseif length(bf_channel_id)>1
    warning('unavailable build');
else
SI(squeeze(sum(obj.pictures{1},3)));hold on;
end
% loop through each cell
for icell=1:obj.numdata
    % draw contour
    plot(obj.data(icell).contour.startcontour(:,1),...
        obj.data(icell).contour.startcontour(:,2),'color',...
        colors(obj.numchannels+1,:));
    hold on;
    if obj.data(icell).good==1
        
        plot(obj.data(icell).contour.box(:,1),...
            obj.data(icell).contour.box(:,2),...
            'color',colors(obj.numchannels+2,:));
        hold on;
    end
    % loop through channel
    for ichannel=1:obj.numchannels
        if strcmp(obj.channeltypes{ichannel},'fp')
        channelname=obj.channelnames{ichannel};
        % plot each particle
        plot(obj.data(icell).(channelname).startpeaks(:,1),...
            obj.data(icell).(channelname).startpeaks(:,2),...
            'o','color',colors(ichannel,:));hold on;
        end
    end
    FigureFormat(gcf)
end

end

