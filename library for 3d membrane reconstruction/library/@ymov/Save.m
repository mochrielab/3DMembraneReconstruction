function [ obj ] = Save( obj, varargin )
%save the result of data
% 3/25/2015
% Yao Zhao

global datapath;
savefile=fullfile(datapath,obj.path,[obj.filename,'.mat']);

if nargin==1
    if exist(savefile)
        choice=questdlg('Do you want to overwrite?',...
            'saving option','Yes','No','Yes');
        switch choice
            case 'Yes'
                mov=obj.mov;
                obj.mov=[];
                save(savefile,'obj');
                obj.mov=mov;
            case 'No'
        end
    else
        mov=obj.mov;
        obj.mov=[];
        save(savefile,'obj');
        obj.mov=mov;
    end
elseif nargin==2
    if varargin{1}<=0
        mov=obj.mov;
        obj.mov=[];
        save(savefile,'obj');
        obj.mov=mov;
    else
        mov=obj.mov;
        obj.mov=[];
        save(savefile,'obj');
        obj.mov=mov;
    end
end


end

