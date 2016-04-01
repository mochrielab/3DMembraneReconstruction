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

isStable = true(size(channeltypes));
for iChannelType=1:length(descriptions)
    switch channeltypes{iChannelType}
        case'None'
        descriptions{iChannelType}='skip this channel';
        case 'BrightfieldContour3D'
            descriptions{iChannelType}='brightfield cells';
        case 'FluorescentParticle3D'
            descriptions{iChannelType}='fluorescent particles';
        case 'FluorescentMembrane3DSpherical'
            descriptions{iChannelType} = 'fluorescent membranes';
        case 'FluorescentMembrane3D'
            descriptions{iChannelType} = 'fluorescent membranes, any shape';
            isStable(iChannelType)=false;
        otherwise 
            descriptions{iChannelType}='can''t find description';
    end
end

channeltypes=channeltypes(isStable);
channelclassnames=channelclassnames(isStable);
descriptions=descriptions(isStable);
end

