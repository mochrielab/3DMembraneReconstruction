function  setter_handles = displaySetterArray(obj,obj_handles,obj_names,varargin)
% display a array of setters for handles of objects
% obj_handles, is an array of handles,
% obj_names, are the display names of the handles
% this function will find properties of each hobj and display setters for
% it in the uiview
% first value of varargin is the selection cell, it select which value to
% display, format is {[1 0 1],[1,0]}

% clear previous handles
obj.clearSetterArray;

% number of handles
numhandles=length(obj_handles);

% if obj names is not given
if isempty(obj_names)
    obj_names=cellfun(@(x)class(x),obj_handles,...
        'UniformOutput',0);
end

% if selection array is input
if isempty(varargin)
    selection= cell(size(obj_handles));
    for ii=1:numhandles
        selection{ii}=ones(size(properties(obj_handles{ii})));
    end
else
    selection = varargin{1};
end


% current row number
current_row = 1;
current_column = 0;
for ihandle=1:numhandles
    % display dimenstions
    %     channel_y0=0.8;
    cell_height=0.06;
    cell_width = 0.3;
    margin=0.01;
    
    % reset current column
    current_column = 0;
    % create a header display of this handle
    
    obj.setter_array_handles(length(obj.setter_array_handles)+1)= ...
        uicontrol('Parent',obj.main_panel,...
        'Style','text',...
        'String',obj_names{ihandle},...
        'Units','normalized','Position',....
        [margin 1-current_row*cell_height cell_width-2*margin cell_height-2*margin],...
        'FontSize',20,'HorizontalAlignment','left');
    % go to next line
    current_row = current_row + 1;
    
    % create an array for each handle setters
    current_handle=obj_handles{ihandle};
    props=properties(current_handle);
    for iprop=1:length(props)
        % property name
        propname = props{iprop};
        % only display numeric field with a length of 1
        if selection{ihandle}(iprop)==1 ...
                && (isnumeric(current_handle.(propname)) ||...
                islogical(current_handle.(propname)))...
                && length(current_handle.(propname))==1
            
            % return to a new line
            if (current_column + 1) * cell_width > 1
                current_column = 0;
                current_row = current_row + 2;
            end
            
            desc = CellVision3D.UIView.getDescription( ...
                class(obj_handles{ihandle}),propname);
            if isempty(desc)
                desc=propname;
            end
            
            % set header display
            obj.setter_array_handles(length(obj.setter_array_handles)+1)= ...
                uicontrol('Parent',obj.main_panel,...
                'Style','text',...
                'String',desc,...
                'Units','normalized','Position',....
                [margin+current_column*cell_width 1-current_row*cell_height cell_width-2*margin cell_height-2*margin],...
                'FontSize',12,'HorizontalAlignment','left');
            
            % set ui control
            if isnumeric(current_handle.(propname))
                obj.setter_array_handles(length(obj.setter_array_handles)+1)= ...
                    uicontrol('Parent',obj.main_panel,...
                    'Style','edit',...
                    'String',num2str(current_handle.(propname)),...
                    'Units','normalized','Position',....
                    [margin+current_column*cell_width 1-(current_row+1)*cell_height cell_width-2*margin cell_height-2*margin],...
                    'FontSize',20,'HorizontalAlignment','left',...
                    'CallBack',@(hobj,eventdata)setParam(hobj,current_handle,propname));
            elseif islogical(current_handle.(propname))
                obj.setter_array_handles(length(obj.setter_array_handles)+1)= ...
                    uicontrol('Parent',obj.main_panel,...
                    'Style','popupmenu',...
                    'String',{'false','true'},...
                    'Value',(current_handle.(propname)+1),...
                    'Units','normalized','Position',....
                    [margin+current_column*cell_width 1-(current_row+1)*cell_height cell_width-2*margin cell_height-2*margin],...
                    'FontSize',20,'HorizontalAlignment','left',...
                    'CallBack',@(hobj,eventdata)setParam(hobj,current_handle,propname));
            end
            % next column
            current_column = current_column + 1;
        end
    end
    
end

end


% call back function for parameter set
function setParam(hobj,hdata,propname)
if strcmpi(get(hobj,'Style'),'edit')
    hdata.(propname) = str2double(get(hobj,'String'));
elseif strcmpi(get(hobj,'Style'),'popupmenu')
    hdata.(propname) = (get(hobj,'Value')==2);
else
    error('wrong type of button');
end

end
