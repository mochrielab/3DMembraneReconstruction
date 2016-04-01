function [  ] = scale( patch, factors)
% scale up the size of the patch according to the bin size
% takes in patch and factors of the patch
% factos format: 1. [all]  2,[scalexy, scalez]  3[scalex, scaley, scalez]
% 3/31/2016 Yao

error('correct scaling error with first base point mismatch? not 1 should be bin/2')


if length(factors)==1
    factors = [factors,factors,factors];
elseif length(factors)==2
    factors = [factors(1),factors(1),factors(2)];
elseif length(Factors)==3
else
    error('wrong length of factors');
end

patch.vertices = (patch.vertices - 1).* (ones(size(patch.vertices,1),1)*factors) + 1;


end

