function varargout=next(obj,varargin)
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
    str=[str,'''',obj.channel_options{...
        get(obj.channel_types_selector_handles(ichannel),'Value')},...
        ''',''',get(obj.channel_labels_edit_handles(ichannel),'String'),...
        ''''];
end
% setup channels
eval(['movie.setChannels(',str,');']);
% load files
movie.load(@(i)obj.progress_bar_handle.setPercentage(i,'loading movie...'));
% output
varargout{1}=movie;
varargout{2}=[];
end

