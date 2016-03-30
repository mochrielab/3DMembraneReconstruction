function [ channeltypes, channelclassnames,descriptions ] = getChannelTypes(  )
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
descriptions=cell(size(channeltypes));
for iChannelType=1:length(descriptions)
    switch channeltypes{iChannelType}
        case'None'
        descriptions{iChannelType}='skip this channel';
        case 'BrightfieldContour3D'
            descriptions{iChannelType}='z stack of brightfield cells';
        case 'FluorescentParticle3D'
            descriptions{iChannelType}='z stack of fluorescent particles';
        case 'FluorescentMembrane3DSpherical'
            descriptions{iChannelType} = 'z stack of fluorescent membranes near spherical shape';
        case 'FluorescentMembrane3D'
            descriptions{iChannelType} = 'z stack of fluorescent membranes, any shape';
        otherwise 
            descriptions{iChannelType}='can''t find description';
    end
end


end

