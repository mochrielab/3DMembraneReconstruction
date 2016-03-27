function [ channeltypes, channelclassnames ] = getChannelTypes(  )
%get all possible channel types for the package
% 3/27/2016 Yao Zhao

%% class meta data of movie
meta=metaclass(CellVision3D.HObject);
packagemeta=meta.ContainingPackage;
classlist = packagemeta.ClassList;
classnames = {classlist.Name};
channelclassnames = ...
    classnames(cellfun(@(x)~isempty(strfind(x,'CellVision3D.Channel')),classnames));
channeltypes=cellfun(@(x)x(21:end),channelclassnames,'UniformOutput',0);
channeltypes{strcmp(channeltypes,'')}='None';
end

