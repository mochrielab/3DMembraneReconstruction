function msd = TimeAveragedMSD(pos,numLags)

msd = zeros(1,numLags);
numframes=size(pos,1);
for iLag = 1:numLags
    rho = zeros(numframes-iLag,1);
    for j = 1:numframes-iLag
        rho(j) = sum((pos(j+iLag,:)-pos(j,:)).^2);
    end
    msd(iLag) = mean(rho);
end

end
