function next(obj)
% go next
% 12/14/2015 Yao Zhao

set(obj.navigation_next_button,'String','Please Wait ...');
for i=1:obj.data.movie.numchannels
    channel=obj.data.movie.getChannel(i);              
    
    % skip if the channel is empty
    if strcmp(channel.type,'None')
        continue;
    end
    
    channel.run(obj.data.cells,...
        @(percentage)obj.progress_bar_handle.setPercentage(percentage,...
        ['analyze ',channel.type,' channel: ',channel.label]),...
        obj.main_panel);
end

end

