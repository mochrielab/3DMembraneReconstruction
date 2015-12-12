function bb=getBoundaries(obj,varargin)
% get boundaries
% Yao Zhao 12/12/2015
currentframe=obj.iframe;
if nargin>=2
    currentframe=varargin{1};
end

% if nargin>=3
%     istack=varargin{2};
% end

bb=cell(length(obj),1);
for icell=1:length(obj)
    % get contours and faces
    if currentframe==0
        vertices=obj(icell).tmpvertices;
        faces=obj(icell).tmpfaces;
    else
        vertices=obj(icell).vertices{currentframe};
        faces=obj(icell).faces{currentframe};
    end
    % calculate intersection
    % ----------------------------------------------1e-5 modifier, will
    % remove in the future
    istack=(mean(vertices(:,3)))+1e-5;
    [ allcontours,lowerfaces,pts] = ...
        CellVision3D.MeshBuilder3D.getCrossSection(vertices,faces,[0 0 1 istack] );
    if ~isempty(allcontours)
        bb{icell}=allcontours{1};
    end
end


end
