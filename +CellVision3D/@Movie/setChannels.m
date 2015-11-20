function [ obj ] = setChannels( obj, varargin )
% set channel information for Movie
% set channel names and types
% example goes here: 
% setChannles('brightfield3d','cellimage','fluorescentmembrane3d',
% 'nucleimembrane','fluorescentparticle3d','spindle pole body')
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
    if sum(strcmp(tmptype,obj.channel_options))==0
    end
%     ichannel
    switch tmptype
        case 'BrightfieldContour3D'
            channels(ichannel)=CellVision3D.ChannelBrightfieldContour3D...
                (varargin{2*ichannel},...
                varargin{2*ichannel-1});
        case 'FluorescentParticle3D'
            channels(ichannel)=CellVision3D.ChannelFluorescentParticle3D...
                (varargin{2*ichannel},...
                varargin{2*ichannel-1});
        case 'FluorescentMembrane3D'
        otherwise
            throw(MException('Movie:NoChannelType',...
                ['cannot find the channel type ',tmptype]));
    end
end
obj.channels=channels;

end

