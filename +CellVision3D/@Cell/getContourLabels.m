function [ labels ] = getContourLabels( cells )
%get all possible labels within the cells

labels={};

for icell=1:length(cells)
    labels=[labels,{cells(icell).contours.label}];
end

labels=unique(labels);

end

