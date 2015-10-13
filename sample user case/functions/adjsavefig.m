function [  ] = adjsavefig( f, xstr,ystr,issave)
% adjust and save figure to figure folder
figure(f);
if ~isempty(xstr)
xlabel(xstr);
end
if ~isempty(ystr)
ylabel(ystr);
end
set(f,'position',[0 50 1200 800]);
if issave>0
saveas(f,['plot--',xstr,'--',ystr],'png');
end

end

