function [ str ] = catname( strcell )
%cant str cell 
str='';
for i=1:length(strcell);
    str=[str,strcell{i},'_'];
end
end

