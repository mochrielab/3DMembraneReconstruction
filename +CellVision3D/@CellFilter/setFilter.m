function obj=setFilter(obj,varargin)
% set the filter
% setFilter(channellabe,filtertype,[valuemin,valuemax],...);
% 3/24/2015 Yao Zhao

n=floor((nargin-1)/3);
for i=1:n
    label=varargin{3*i-2};
    type=varargin{3*i-1};
    value=varargin{3*i};
    try
        filter=obj.(type);
    catch
        warning('type not supported')
    end
    % find if label exist
    if ~isempty(filter)
        labelid=find(strcmp(label,{filter.label}));
    else
        labelid=[];
    end
    if ~isempty(labelid)
        obj.(type)(labelid).min=value(1);
        obj.(type)(labelid).max=value(2);
    else
        s=[];
        s.label=label;
        s.min=value(1);
        s.max=value(2);
        obj.(type)=[obj.(type),s];
    end
end
end