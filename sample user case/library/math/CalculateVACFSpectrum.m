function  [meanvacf,stdvacf] = CalculateVACFSpectrum(X,maxdelta,maxtau)

dim = size(X{1},2);
numTracks = length(X);
meanvacf = zeros(maxdelta,maxtau);
stdvacf = zeros(maxdelta,maxtau);
for j = 1:maxdelta
    vacf = zeros(numTracks,maxtau);
    for i = 1:numTracks
        pos = X{i};
        for k = 1:j
            tmpvacf = 0; 
            for m = 1:dim
                x = diff(pos(k:j:end,m));
                Cx = x*x';
                tmpvacf = tmpvacf + CalculateVACF(Cx);
            end
            N = min(length(tmpvacf),maxtau);
            vacf(i,1:N) = vacf(i,1:N) + tmpvacf(1:N)/dim;
        end
    end
    for i = 1:maxtau 
        index = find(vacf(:,i) ~= 0); 
        meanvacf(j,i) = mean(vacf(index,i));
        stdvacf(j,i) = std(vacf(index,i))/sqrt(length(index));
    end
end





