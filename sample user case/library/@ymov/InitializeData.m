function [ obj ] = InitializeData( obj, mainchannel,varargin)
% initialize the data for movie analysis
% mainchannel is the channel to build the core
% if the channel type is particle, build around center
% if the channel type is boundary, build around contours
% 3/22/2015
% Yao Zhao



ind=find(strcmp(mainchannel,obj.channelnames));
if strcmp(mainchannel,'cellcontour')
    contourdata=obj.cellcontour_ff;
elseif ~isempty(ind)
else
    error('wrong main channel name');
end


if strcmp(contourdata.type,'contour')
    % number of cell
    numcell=length(contourdata.boundaries);
    % data initial
    tmp=struct();
    for ichannel=1:obj.numchannels
        tmp.(obj.channelnames{ichannel})=[];
    end
    tmp.contour=[];
    tmp.good=0;
    tmp(1:numcell)=tmp;
    objdata=tmp;
    % get particles
    %     goodcell1=true(numcell,1);
    for ichannel=1:obj.numchannels
        if strcmp(obj.channeltypes{ichannel},'bf')
        elseif strcmp(obj.channeltypes{ichannel},'fm')
        elseif strcmp(obj.channeltypes{ichannel},'fp')
            channelname=obj.channelnames{ichannel};
            peaks=obj.particle_ff.(channelname).peaks;
            for icell=1:numcell
                bb=contourdata.boundaries{icell};
                % bb xy order in reversed
                [in] = inpolygon(peaks(:,1),peaks(:,2),bb(:,2),bb(:,1));
                objdata(icell).contour.startcontour=[bb(:,2),bb(:,1)];
                objdata(icell).(channelname).startpeaks=peaks(in,:);
                objdata(icell).(channelname).numpeaks=sum(in);

            end
        end
    end
    
    % save data
    obj.data=objdata;
    obj.numdata=length(obj.data);
    obj.GetContourProperties;
    obj.Filter_RCM;
    %     goodcell=goodcell1 & goodcell2;
    
    % plot
    for i=1:nargin-2
        if strcmp(varargin{i},'showplot')
            obj.ShowCellSelection;
        end
    end
    
    % resave data
    obj.data=obj.data(logical([obj.data.good]));
    obj.numdata=length(obj.data);
else
    error('wrong type of main channel');
end





end

