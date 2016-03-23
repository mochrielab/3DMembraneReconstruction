function next(obj)
% go next
% 12/14/2015 Yao Zhao

%%

% create movie
movie=obj.data.movie;
% number of channels
numchannels=movie.numchannels;
types=cell(numchannels,1);
for i=1:numchannels
    types{i}=movie.getChannel(i).type;
end

contours=obj.data.channelresults(strcmp(types,'BrightfieldContour3D'));
membranes=obj.data.channelresults(strcmp(types,'FluorescentMembrane3D'));
particles=obj.data.channelresults(strcmp(types,'FluorescentParticle3D'));

% get the construction method of cell
[constructionmethods,descriptions]=CellVision3D.Cell.getCellConstructionMethods;
constructionmethod=constructionmethods{obj.cell_methods_selector_handle.get('Value')};

% construct the cell
switch constructionmethod
%     case 'constructCellsByContourParticles'
    case 'constructCellsByMembraneParticles'
        if length(membranes)==1 && length(particles)>=1
            cells=CellVision3D.Cell.constructCellsByMembraneParticles...
                (membranes{1},particles{:});
        else
            throw(MException('UIViewInit:NotSupported',...
                'channel numbers doesnt match'))
        end
%     case 'constructCellsByContour'
    case 'constructCellsByMembrane'
        if length(membranes)==1 
            cells=CellVision3D.Cell.constructCellsByMembrane...
                (membranes{1});
        else
            throw(MException('UIViewInit:NotSupported',...
                'channel numbers doesnt match'))
        end
%     case 'constructCellsByParticles'
    otherwise
        cells=[];
        throw(MException('UIViewInit:NotSupported',...
            'cell construction method not supported'))
end
obj.progress_bar_handle.setPercentage(1,'finished constructing cells');

% set filters
str=[];
for i=1:size(obj.cell_filters_handles,1)
    % filter type
    filtertypes=get(obj.cell_filters_handles(i,1),'String');
    filterind=get(obj.cell_filters_handles(i,1),'Value');
    filtertype=filtertypes{filterind};
    if ~strcmp(filtertype,'none') && ishandle(obj.cell_filters_handles(i,2))
        % channel label
        labels=get(obj.cell_filters_handles(i,2),'String');
        labelid=get(obj.cell_filters_handles(i,2),'Value');
        label=labels{labelid};
        % get range
        str=[str,'''',label,''',''',filtertype,''',[',...
            get(obj.cell_filters_handles(i,3),'String'),' ',...
            get(obj.cell_filters_handles(i,4),'String'),'],'];
    end
end

eval(['filter=CellVision3D.CellFilter(',str(1:end-1),');']);
cells=filter.applyFilter(cells);
% 
% % for test mode only use the first 2 cells
% cells=cells(1:2);

% output
obj.data.cells=cells;

end

