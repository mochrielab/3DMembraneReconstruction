% script for er testing
% this is a script example to show how to analyze the default sample

%% setting up and load movie
clear all;clc;close all
% addpath('./bioformats');
% select movie file
moviename = 'Nup82_WT_TL_03_R3D.dv';
movie=CellVision3D.Movie(moviename);
moviename = moviename(1:end-4);
% set channels
% movie.setChannels('FluorescentParticle3D','lacO',...
%     'FluorescentMembrane3DSpherical','hmg1');
% movie.setChannels('None','trans','None','GFP','FluorescentParticle3D','lacO',...
%     'FluorescentMembrane3DSpherical','cut11');
movie.setChannels('FluorescentMembrane3DSpherical','Nup82');
% load movie to RAM
movie.load();
%% initialize lacO channel
% % get channel
% channel1 = movie.getChannel('lacO');
% % initialize the channel 
% particles = channel1.init(1);
% % preview channel
% channel1.view();
%% initialize Membrane channel
% get Membrane channel
channel2 = movie.getChannel('Nup82');
% set size of object
channel2.lobject = 30;
% channel2.lnoise = 0.5;
% initialize Membrane channel
contours = channel2.init(1);
% preview channel
channel2.view();
saveas(gcf,sprintf('%s_init',moviename),'png')
%% construct cell 
% construct the cell only by membrane
% cells = CellVision3D.CellConstructor.constructCellsByMembraneParticles(contours,particles);
cells = CellVision3D.CellConstructor.constructCellsByMembrane(contours);
% set filters to only select cells with two lacO found
% filter=CellVision3D.CellFilter('lacO','FluorescentParticle3D_number',[1 1]);
% apply filtter
% cells=filter.applyFilter(cells);
% view the movie
movie.view(cells);
saveas(gcf,sprintf('%s_construct',moviename),'png')
%% reconstruct the cells
%only choose the first 5 cells to for test purpose
% cells=cells(1:5);
% run the analysis based on constructed cells
f=figure('Position',[50 50 1200 800]);
% channel1.run(cells,[],f);
moviename = 'Nup82_WT_TL_03_R3D';
channel2.run(cells,[],f,moviename);
saveas(gcf,sprintf('%s_cell_%d',moviename),'png')
% run without the images, much faster
% channel1.run(cells);
% channel2.run(cells);
%% analyze the cells
% CellVision3D.CellAnalyzer.extractParticleContourDistance(cells,'lacO','cut11');
CellVision3D.CellAnalyzer.extractContourMeanRadius(cells,'Nup82');
CellVision3D.CellAnalyzer.extractContourVolume(cells,'Nup82');
% CellVision3D.CellAnalyzer.extractParticleContourDistanceRelative(cells,'lacO','cut11');

%% save the result
% save the full result to the directory of the movie files
isoverride = 1;
movie.save(isoverride);
% export only the runned analysis
cells.exportCSV(sprintf('%s.csv',moviename))
