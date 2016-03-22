function next(obj)
% go next
% 12/14/2015 Yao Zhao


% get filename
try
    [FileName,PathName,FilterIndex] = ...
        uiputfile('*.mat','Please create a .mat file to save result',...
        obj.data.movie.filename);
catch
    [FileName,PathName,FilterIndex] = ...
        uiputfile('*.mat','Please create a .mat file to save result',...
        'result');
end
% save file
try
    obj.data.movie.save(1,fullfile(PathName,FileName));
    cells=obj.data.cells;
    save(fullfile(PathName,FileName),'cells','-append');
catch error
    msgbox(error.message);
end
end



