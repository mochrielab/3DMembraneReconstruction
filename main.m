
%% get picture
close all;
clear all;
clc;
% set location of dv movies
rootpath='C:\nuclei';
moviename='wild_type_04.dv';
mt=mitosis(fullfile(rootpath,moviename));
% load movie first 100 frames
mt.loadmovie(100*10);
%% get wimg3
frames=1:100;
zxr=mt.vox/mt.pix*mt.aberation;
data(1:length(frames))=mesh3(0,zxr);
for i=1:1:length(frames)
    %%
    iframe=frames(i);
    img3=mt.grab3(iframe);
    wimg3=img3(130:200,130:190,:);
    
    %get mesh
    obj=mesh3(wimg3,zxr);
    obj.diagnostic_mod_on=0;
%     obj.cost=.1;
    
%     if iframe==frames(1);
        display('initialize mesh');
        tic
        obj.InitializeMesh;
        toc
        
        display('optimize mesh');
        tic
        obj.OptimizeMesh;
        toc
        
        display('label id');
        tic
        obj.LabelPatchId;
        toc
        
        display('align face direction');
        tic
        obj.AlignFaceDirection;
        obj.GetVertexNormalDirection;
        toc
%         obj.PlotMesh
%     else
%         obj.CopyFrom(oldobj);
%         obj.rawimage=wimg3;
%         obj.PreProcessImage;
%     end
    
    obj.GetSurfaceInterpImage;
    display('fit surface');
%     tic
%     obj.cost=1;
%     obj.FitSurface(0.01);
%     toc
%     obj.PlotMeshStack
    %%
    obj.cost=.1;
    obj.FitSurface;
    toc
    oldobj=obj;
    obj.PlotMeshStack(.5);
%     pause(.1)
    display('save data')
    obj.identifier=iframe;
    data(i)=obj;
end
save('data.mat','data')
%%

for i=1:length(data)
    clf
%     data(i).PlotMeshStack(.1);
data(i).PlotMesh
%     SI(squeeze(data(i).rawimage(:,:,7)))
    pause(.1)
end





