% script for er testing
% this is a script example to show how to analyze the default sample

%% setting up and load movie

addpath('./bioformats');
clear all;clc;close all
% select movie file
movie=CellVision3D.Movie('sample_image.dv');
% set channels
movie.setChannels('FluorescentParticle3D','lacO',...
    'FluorescentMembrane3DSpherical','cut11');
% load movie to RAM
movie.load();
%% initialize lacO channel
% get channel
channel1 = movie.getChannel('lacO');
% initialize the channel 
particles = channel1.init(1);
% preview channel
channel1.view();
%% initialize Membrane channel
% get Membrane channel
channel2 = movie.getChannel('cut11');
% initialize Membrane channel
contours = channel2.init(1);
% preview channel
channel2.view();
%% construct cell 
% construct the cell only by membrane
cells = CellVision3D.CellConstructor.constructCellsByMembraneParticles(contours,particles);
% set filters to only select cells with two lacO found
filter=CellVision3D.CellFilter('lacO','FluorescentParticle3D_number',[1 1]);
% apply filtter
cells=filter.applyFilter(cells);
% view the movie
movie.view(cells);
%% reconstruct the cells
%only choose the first 5 cells to for test purpose
cells=cells(1:5);
% run the analysis based on constructed cells
% f=figure('Position',[50 50 1200 600]);
% channel1.run(cells,[],f);
% channel2.run(cells,[],f);
% run without the images, much faster
channel1.run(cells);
channel2.run(cells);
%% analyze the cells
CellVision3D.CellAnalyzer.extractParticleContourDistance(cells,'lacO','cut11');
CellVision3D.CellAnalyzer.extractContourMeanRadius(cells,'cut11');
CellVision3D.CellAnalyzer.extractContourVolume(cells,'cut11');
CellVision3D.CellAnalyzer.extractParticleContourDistanceRelative(cells,'lacO','cut11');

%% save the result
% save the full result to the directory of the movie files
isoverride = 1;
movie.save(isoverride,[],cells);
% export only the runned analysis
h = figure;
cells.exportCSV('sample_image_.csv')
movie.view(cells);
print(gcf,'sample_image.png','-dpng');
close(h);
