function [ obj ] = setChannels( obj, varargin )
% set channel information for Movie
% set channel names and types
% example goes here: 
% setChannles('BrightfieldContour3D','cellimage','FluorescentMembrane3D',
% 'nucleimembrane','FluorescentParticle3D','spindle pole body')
% 3/21/2015
% Yao Zhao

% check input format
n=nargin-1;
if mod(n,2)==1
    error('wrong number of input');
end
% initialize
obj.numchannels=n/2;
channels=repmat(CellVision3D.Channel.empty,1,n/2);
for ichannel=1:obj.numchannels
    tmptype=varargin{2*ichannel-1};

    % get types of channels
    [types,classnames,descr]=CellVision3D.Channel.getChannelTypes();

    % if specified type can be fonud
    if sum(strcmp(tmptype,types))
        eval(['channels(ichannel)=',classnames{strcmp(tmptype,types)},...
            '(varargin{2*ichannel},varargin{2*ichannel-1});']);
    else
        throw(MException('Movie:NoChannelType',...
            ['cannot find the channel type ',tmptype]));
    end

%     switch tmptype
%         case 'BrightfieldContour3D'
%             channels(ichannel)=CellVision3D.ChannelBrightfieldContour3D...
%                 (varargin{2*ichannel},...
%                 varargin{2*ichannel-1});
%         case 'FluorescentParticle3D'
%             channels(ichannel)=CellVision3D.ChannelFluorescentParticle3D...
%                 (varargin{2*ichannel},...
%                 varargin{2*ichannel-1});
%         case 'FluorescentMembrane3DSpherical'
%             channels(ichannel)=CellVision3D.ChannelFluorescentMembrane3D...
%                 (varargin{2*ichannel},...
%                 varargin{2*ichannel-1});
%         case 'None'
%             channels(ichannel)=CellVision3D.Channel...
%                 (varargin{2*ichannel},...
%                 varargin{2*ichannel-1});
%         otherwise
%             throw(MException('Movie:NoChannelType',...
%                 ['cannot find the channel type ',tmptype]));
%     end
end
obj.channels=channels;

end

