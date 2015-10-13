function savefigure(name)
mkdir('figures');
name=fullfile('figures',name);
savefig(name)
print(gcf,[name,'.png'],'-dpng');
print(gcf,[name,'.eps'],'-depsc');
end