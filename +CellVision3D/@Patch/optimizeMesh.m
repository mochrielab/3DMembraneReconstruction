function [ p ] = optimizeMesh( p )
%% optimize the mesh network
% only works if each faces has 3 edges
% 3/12/2015 Yao Zhao

%% get edges and neighbors

for i=1:2
    tic
    p.balanceTopology;
    p.balancePoints;
    p.splitLargeQaudrangle(p.mesh_size );
    p.removeThreeWayConnectionPoints;
    p.removeFourWayConnectionPoints;
    toc
end
p.balanceTopology;
p.balancePoints;
p.labelPatch;


end

