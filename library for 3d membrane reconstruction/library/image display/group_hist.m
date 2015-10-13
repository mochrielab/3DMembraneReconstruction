function [f1,f2] = group_hist( datain,colorall,bins1,legendnames)
%plot histogram fro data
f1=figure;
f2=figure;
for i=1:length(datain)
    if isempty(bins1)
        [counts,bins2]=hist(datain{i});
    else
        [counts,bins2]=hist(datain{i},bins1);
    end
    counts=counts/sum(counts);
    cumcounts=cumsum(counts);
    figure(f1)
    plot(bins2,counts,'color',colorall(i,:)); hold on;
    figure(f2)
    plot(bins2,cumcounts,'color',colorall(i,:)); hold on;
end
figure(f1);legend(legendnames);FigureFormat(f1);
figure(f2);legend(legendnames);FigureFormat(f2);


end

