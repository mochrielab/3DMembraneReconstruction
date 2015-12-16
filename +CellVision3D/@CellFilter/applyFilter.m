function  cells=applyFilter(obj,cells)

% use filter to filter cells
% 11/18/2015 Yao Zhao
chooseind=true(size(cells));
for icell=1:length(cells)
    %% number filters
    filter=obj.FluorescentParticle3D_number;
    for itype=1:length(filter)
        label=filter(itype).label;
        labels={cells(icell).particles.label};
        inumber=sum(strcmp(labels,label));
        if inumber<filter(itype).min || inumber>filter(itype).max
            chooseind(icell)=false;
        end
    end
end

cells=cells(chooseind);

end

