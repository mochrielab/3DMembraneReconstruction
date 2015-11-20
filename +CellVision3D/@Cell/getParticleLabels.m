function [ labels ] = getParticleLabels( cells )
%get all possible labels within the cells

labels={};

for icell=1:length(cells)
    labels=[labels,{cells(icell).particles.label}];
end

labels=unique(labels);

end

