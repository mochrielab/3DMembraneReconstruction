function next(obj)
% go next
% 12/14/2015 Yao Zhao

% create movie
movie=CellVision3D.Movie(obj.movie_filename_text_handle.get('String'));
% number of channels
numchannels=obj.number_channel_selector_handle.get('Value');
str=[];
for ichannel=1:numchannels
    if ichannel>1
        str=[str,','];
    end
    str=[str,'''',CellVision3D.Channel.getChannelTypes(){...
        get(obj.channel_types_selector_handles(ichannel),'Value')},...
        ''',''',get(obj.channel_labels_edit_handles(ichannel),'String'),...
        ''''];
end
% setup channels
eval(['movie.setChannels(',str,');']);

% set illuminations
try
    for ichannel=1:numchannels
        channel=movie.getChannel(ichannel);
        if ~isempty(strfind(lower(channel.type),'fluorescentparticle'))
            channel.setIlluminationcorrection(movie.path);
        end
    end
catch
end

% peek movie parameters before loading movie
movie.peek;

%% set input parameters
% update buttion text
waitforbutton =1;
obj.navigation_next_button.set('String','Confirm Movie Parameters','Callback',@(hobject,eventdata)uiresume);

obj.clearMainPanel;
% create parameter array
obj.displaySetterArray({movie},[]);


uiwait;

% wait for the figure to close by pressing next channel
obj.clearSetterArray;
%% load the data

% load files
movie.load(@(i)obj.progress_bar_handle.setPercentage(i,'loading movie...'));
% output
obj.data.movie=movie;


  
end

