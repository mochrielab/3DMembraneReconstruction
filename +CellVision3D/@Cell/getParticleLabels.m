function [ labels ] = getParticleLabels( cells )
%get all possible labels within the cells



labels=[];

for icell=1:length(cells)
    if ~isempty(cells(icell).particles)
        labels=[labels,{cells(icell).particles.label}];
    end
end

labels=unique(labels);

end

