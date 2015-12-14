function varargout=next(obj,varargin)
% go next
% 12/14/2015 Yao Zhao

% create movie
movie=varargin{1};
% number of channels
numchannels=movie.numchannels;
output=cell(numchannels,1);
types=cell(numchannels,1);
for i=1:numchannels
    output{i}=movie.getChannel(i).init(1);
    types{i}=movie.getChannel(i).type;
end

contours=output(strcmp(types,'BrightfieldContour3D'));
membranes=output(strcmp(types,'FluorescentMembrane3D'));
particles=output(strcmp(types,'FluorescentParticle3D'));

% get the construction method of cell
[constructionmethods,descriptions]=CellVision3D.Cell.getCellConstructionMethods;
constructionmethod=constructionmethods{obj.cell_methods_selector_handle.get('Value')};

% construct the cell
switch constructionmethod
    case 'constructCellsByContourParticles'
    case 'constructCellsByMembraneParticles'
        if length(membranes)==1 && length(particles)>=1
            cells=CellVision3D.constructCellsByMembraneParticles...
                (membranes{1},particles{:});
        else
            throw(MException('UIViewInit:NotSupported',...
                'channel numbers doesnt match'))
        end
    case 'constructCellsByContour'
    case 'constructCellsByMembrane'
    case 'constructCellsByParticles'
    otherwise
        throw(MException('UIViewInit:NotSupported',...
            'cell construction method not supported'))
end

% output
varargout{1}=movie;
varargout{2}=cells;
end

