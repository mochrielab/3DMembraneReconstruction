function [ labels ] = getContourLabels( cells )
%get all possible labels within the cells

labels=[];

for icell=1:length(cells)
    if ~isempty(cells(icell).contours)
        labels=[labels,{cells(icell).contours.label}];
    end
end

labels=unique(labels);

end

