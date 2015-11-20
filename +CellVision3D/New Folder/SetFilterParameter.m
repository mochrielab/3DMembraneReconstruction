function [ obj ] = SetFilterParameter( obj, varargin )
%set filter paramteter
% sample: channelname, fieldname, value, field name, value 
% Yao Zhao
% 3/23/2015

if isempty(find(strcmp(obj.channelnames,varargin{1})))
    error('wrong channel name');
end

for i=2:2:nargin-2 
    
if isempty(find(strcmp(fieldnames(obj.filterparam.(varargin{1})),varargin{i})))
    error('wrong field name');
end
    obj.filterparam.(varargin{1}).(varargin{i})=varargin{i+1};
end

end

