function [ movie ] = save( movie,isoverride,varargin )
% save the result of move file along with cell data
% varargin can be used to save additional data
%
% 3/25/2015
% Yao Zhao
savefile=fullfile(movie.path,[movie.filename,'.mat']);
if length(varargin)>=1
    if ~isempty(varargin{1})
        savefile=varargin{1};
    end
end

if exist(savefile,'file') && isoverride==0
    choice=questdlg('Do you want to overwrite?',...
        'saving option','Yes','No','Yes');
    switch choice
        case 'Yes'
            isoverride=1;
        case 'No'
    end
end

if isoverride || ~exist(savefile,'file')
    movs=cell(1,movie.numchannels);
    for i=1:movie.numchannels
        movs{i}=movie.getChannel(i).unloadData;
    end
    save(savefile,'movie');
    for i=1:movie.numchannels
        movie.getChannel(i).load(movs{i});
    end
    
    % append cell data into the movie
    if length(varargin)>=2
        cells=varargin{2};
        save(savefile,'cells','-append')
    end
    
end



end

