function [ obj ] = OptimizeMesh( obj )
%% optimize the mesh network
% only works if each faces has 3 edges
% 3/12/2015 Yao Zhao

%% get edges and neighbors
%         obj.BalanceTopology;
%         obj.BalancePoints;
for i=1:2
    tic
    obj.BalanceTopology;
    obj.BalancePoints;
    obj.SplitLargeQaudrangle(obj.mesh_size);
    obj.BalanceTopology;
    obj.BalancePoints;
    obj.RemoveThreeWayConnectionPoints;
    obj.RemoveFourWayConnectionPoints;
%     obj.BalanceNeighborNumber;
%             obj.RemoveNearbyFiveWayConnectionPoints;
%     obj.PlotMeshSim;pause;
    toc
    %   patchdata.BalaceTriangleArea;
end
obj.BalanceTopology;
obj.BalancePoints;
obj.DiagnoseMeshTopology;
end

