% script for er testing
% this is a script example to show how to analyze the default sample

%% setting up and load movie
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
%% initialize ER channel
% get ER channel
channel2 = movie.getChannel('cut11');
% initialize ER channel
contours = channel2.init(1);
% preview channel
channel2.view();
%% construct cell 
% construct the cell only by membrane
cells = CellVision3D.CellConstructor.constructCellsByMembraneParticles(contours,particles);
% view the movie
movie.view(cells);
%% reconstruct the cells
%only choose the first two cells to for test purpose
cells=cells(1:2);
% run the analysis based on constructed cells
f=figure;
channel1.run(cells,@(x)1,f);
channel2.run(cells,@(x)1,f);
%% analyze the cells
CellVision3D.CellAnalyzer.extractParticleContourDistance(cells,'lacO','cut11');

%%
% data.movie=movie;
% data.cells=cells;
% ui=CellVision3D.UIViewAnalyze(data);
% 
% ui.next();
% 
