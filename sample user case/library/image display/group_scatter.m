function [ f ] = group_scatter( datain1,datain2,colorall,legendnames )
%plot scatter plots for groups
f=figure;
for i=1:length(datain1)
    plot(datain1{i},datain2{i},'.','color',colorall(i,:));hold on;
end
legend(legendnames);FigureFormat(f);
end

