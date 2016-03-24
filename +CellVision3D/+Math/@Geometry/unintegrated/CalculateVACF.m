function  vacf = CalculateVACF(C)

N = length(C);
subC = zeros(N);
for j = 1:N
    subC(j,1:(N-j+1)) = C(j,j:end);
end
vacf = sum(subC)./(N:-1:1);
    




