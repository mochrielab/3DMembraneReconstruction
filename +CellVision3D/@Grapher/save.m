function [  ] = save( filename )
%SAVE Summary of this function goes here
%   Detailed explanation goes here

[dirpath,file,ext]=fileparts(filename);

switch ext
    case '.png'
        codec='-dpng';
    case '.pdf'
        codec='-dpdf';
end

set(gcf,'Unit','Pixel');
pos=get(gcf,'Position');
set(gcf,'PaperPosition',[0 0 pos(3:4)/100]);
print(gcf,filename,codec);

filename2=fullfile(dirpath,[file,'.eps']);
print(gcf,filename2,'-deps');

filename3=fullfile(dirpath,[file,'.fig']);
savefig(filename3);


end

