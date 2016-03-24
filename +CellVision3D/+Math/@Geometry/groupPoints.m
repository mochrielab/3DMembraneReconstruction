function [ groups] = groupPoints( points, th, options, varargin )
% group a set of points based on a distance threshold
% group stores the index of p instead of values
% options are 'distance from center' and 'distance between each other'
% support both 2d and 3d, optional input zxr for 3d
% 3/24/2015 Yao Zhao


% set the z to x ratio for 3dimension
if nargin ==3
    zxr=1;
elseif nargin ==4
    zxr = varargin{1};
else
end

% append index to the particles
points = [points,(1:size(points,1))'];

% check different options
switch options
    case 'distance from center'
        groups=[];
        centers=[];
        [groups,centers] = groupRecursionDFC(groups,centers,points);
    case 'distance between each other'
    otherwise
        error('not supported groupPoints mode')
end

% recursion function to group distance from the center
function [groups,centers] = groupRecursionDFC(groups,centers,points)
    if isempty(points)
        % if points is empty return groups
        return
    elseif isempty(groups)
        % if group isempty, put first point in the group
        groups={points(1,end)};
        centers=points(1,1:end-1);
        [groups,centers] = groupRecursionDFC(groups,centers,points(2:end,:));
    else
        % calculate the group without the first point, and add the first
        % point back
        [groups,centers] = groupRecursionDFC(groups,centers,points(2:end,:));
        % calculate the distance between the first points and rest of the
        % centers
        point1=points(1,:);
        numgroups = length(groups);
        distance = CellVision3D.Math.Geometry.getDistance...
            (centers,ones(numgroups,1)*point1(1:end-1),zxr);
        % if the min distance is smaller 
        [mindist,mindistind]=min(distance);
        if mindist<th
            % number of previous points in the group
            numtmp = length(groups{mindistind});
            % add index to the group
            groups{mindistind}=[groups{mindistind},point1(end)];
            % update center
            centers(mindistind,:)=...
                (centers(mindistind,:)*numtmp+point1(1:end-1))/(numtmp+1);
        else
            % add a new group
            groups=[groups,{point1(end)}];
            centers=[centers;point1(1:end-1)];
        end

    end
end

end



