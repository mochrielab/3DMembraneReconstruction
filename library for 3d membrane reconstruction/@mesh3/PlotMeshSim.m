function [ obj ] = PlotMeshSim( obj )
%plot a simple mesh
% 3/12/2015 Yao Zhao

clf
p1.vertices=obj.vertices;
p1.faces=obj.faces;

SP(p1,'r','k');
axis off;
camlight
lighting gouraud

end

