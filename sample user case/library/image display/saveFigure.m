function saveFigure(datapath, name)
% make a folder "figures" under the targerted directory
% save the figure in to the "figures" folder

if ~exist(fullfile(datapath,'figures'),'dir')
    mkdir(fullfile(datapath,'figures'));
end
name=fullfile(datapath,'figures',name);
savefig(name)
print(gcf,[name,'.png'],'-dpng');
print(gcf,[name,'.eps'],'-depsc');

end