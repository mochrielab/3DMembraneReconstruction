function [  ] = save_contour( nm,varargin )
%%
savefile=fullfile(nm.path,[nm.filename,'.mat']);

if nargin==1
    if exist(savefile)
        choice=questdlg('Do you want to overwrite?',...
            'saving option','Yes','No','Yes');
        switch choice
            case 'Yes'
                mov=nm.mov;
                nm.mov=[];
                save(savefile,'nm');
                nm.mov=mov;
            case 'No'
        end
    else
        mov=nm.mov;
        nm.mov=[];
        save(savefile,'nm');
        nm.mov=mov;
    end
elseif nargin==2
    if varargin{1}==0
        nm.mov=[];
        save(savefile,'nm');
    else
        mov=nm.mov;
        nm.mov=[];
        save(savefile,'nm');
        nm.mov=mov;
    end
end

end

