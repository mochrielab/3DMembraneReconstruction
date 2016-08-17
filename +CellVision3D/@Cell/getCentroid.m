function cnt = getCentroid( cells )
% get the centroid of the cells
% 6/20/2016 Yao Zhao

cnt = zeros(length(cells),3);
if ~isempty(cells(1).contours)
    for icell = 1:length(cells)
        for icontour = 1:length(cells(icell).contours)
            tmp = cells(icell).contours(icontour).getCentroid();
            cnt(icell,1:length(tmp)) = cnt(icell,1:length(tmp))+tmp;
        end
    end
else
    for icell = 1:length(cells)
        for iparticle = 1:length(cells(icell).particles)
            tmp = cells(icell).particles(iparticle).getCentroid();
            cnt(icell,1:length(tmp)) = cnt(icell,1:length(tmp))...
                +tmp/length(cells(icell).particles);
        end
    end
end


end

