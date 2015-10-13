function [ obj ] = SetChannel( obj, varargin )
% set channel information for ymov
% set channel names and types
% example goes here: 'bf','cellimage','fm','nucleimembrane','fp','spindle pole body'
% 3/21/2015
% Yao Zhao

possibletypes=[{'bf'},{'fm'},{'fp'}];

n=nargin-1;
if mod(n,2)==1
    error('wrong number of input');
end

obj.numchannels=n/2;
obj.channeltypes=cell(n/2,1);
obj.channelnames=cell(n/2,1);
for ichannel=1:obj.numchannels
    tmptype=varargin{2*ichannel-1};
    if sum(strcmp(tmptype,possibletypes))==0
        error(['cannot find the channel type ',tmptype]);
    end
    obj.channeltypes{ichannel}=varargin{2*ichannel-1};
    obj.channelnames{ichannel}=varargin{2*ichannel};
    if strcmp(obj.channeltypes{ichannel},'fp')
        % set filtering parameters for fluroescent particles
        tmp=[];
        tmp.number_min=0;
        tmp.number_max=inf;
        tmp.longaxis_distance_from_center_min=0;
        tmp.longaxis_distance_from_center_max=inf;
        tmp.shortaxis_distance_from_center_min=0;
        tmp.shortaxis_distance_from_center_max=inf;
        obj.filterparam.(obj.channelnames{ichannel})=tmp;
    elseif strcmp(obj.channeltypes{ichannel},'fm')
         % set filtering parameters for fluroescent membrane
    elseif strcmp(obj.channeltypes{ichannel},'bf')
        % set filtering parameters for bright field
    end
end


end

