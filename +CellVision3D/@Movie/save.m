function [ obj ] = save( obj,isoverride )
% save the result of move file along with cell data
% varargin can be used to save additional data
%
% 3/25/2015
% Yao Zhao

savefile=fullfile(obj.path,[obj.filename,'.mat']);

if exist(savefile,'file') && isoverride==0
    choice=questdlg('Do you want to overwrite?',...
        'saving option','Yes','No','Yes');
    switch choice
        case 'Yes'
            isoverride=1;
        case 'No'
    end
end

if isoverride
    movs=cell(1,obj.numchannels);
    for i=1:obj.numchannels
        movs{i}=obj.getChannel(i).unloadData;
    end
    save(savefile,'obj');
    for i=1:obj.numchannels
        obj.getChannel(i).load(movs{i});
    end
end

end

