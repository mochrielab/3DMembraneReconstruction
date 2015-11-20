function [ obj ] = FirstFrameParticle( obj, id, varargin )
% get particles for the first frame
% 3/22/2015
% Yao Zhao


%%

if isa(id,'char')
    id=find(strcmp(id,obj.channelnames));
elseif isa(id,'numeric')
else
    error('unsupported channelname type');
end

end

