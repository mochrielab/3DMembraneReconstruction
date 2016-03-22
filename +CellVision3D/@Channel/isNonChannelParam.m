function array = isNonChannelParam( obj )
% get the array of param that doesnt belong to Channel
% which means it inherited from other class
% used for its sublcasses

% my propnames
mypropnames = properties(obj);
% channel propnames
channelprop = properties('CellVision3D.Channel');
% array for non channel param
% array = zeros(size(mypropnames));
array = cellfun(@(x)~sum(strcmp(x,channelprop)),mypropnames);


end

