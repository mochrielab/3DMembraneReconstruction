% script for mamalian cell testing
% this is a script example to show how to analyze mamlian nucleus only
% using script


%% setting up and load movie
clear all;close all;clc;
addpath('./bioformats');
channellabel='lacO';
% select movie file
movie=CellVision3D.Movie('sample_image_doubleparticle.TIF');
% display all possible channel types
display(CellVision3D.Channel.getChannelTypes())
% set channels
movie.setChannels('FluorescentParticle3D',channellabel);
% set voxel value because .TIF doesn't contain it
movie.vox2um=0.2;
% load movie to RAM
movie.load();
%% initialize channel
% get channel
channel = movie.getChannel(channellabel);
% set the size of object to 100
channel.lobject=3;
% reset peak threshold, some of the particles are really dim, 
channel.peakthreshold = .1;
% reset minimum distance between particles
channel.mindist = 3;
% initialize the movie 
results = channel.init(1);
% preview channel
channel.view();
%% construct cell 
% construct the cell only by membrane
clc
cells = CellVision3D.CellConstructor.constructCellsByParticles(results);
% set filters to only select cells with two lacO found
filter=CellVision3D.CellFilter(channellabel,'FluorescentParticle3D_number',[2 2]);
% apply filtter
cells=filter.applyFilter(cells);
% view result
movie.view(cells);
%% reconstruct cell
cells=cells(1:5); % only choose first 2 cells to make it faster for testing
% run with images (slow)
% f=figure('Position',[50 50 1200 600]);
% channel.run(cells,[],f);
% run without images (much faster)
channel.run(cells);
%% run the analysis based on constructed cells
% run particle distance analysis
CellVision3D.CellAnalyzer.extractParticlePairDistance(cells, channellabel)
CellVision3D.CellAnalyzer.extractParticleNumber(cells, channellabel)
CellVision3D.CellAnalyzer.extractParticleSize(cells, channellabel)
CellVision3D.CellAnalyzer.extractParticleIntensity(cells, channellabel)
%% save the result
% save the full result to the directory of the movie files
isoverride = 1;
movie.save(isoverride);
% export only the runned analysis
cells.exportCSV('test.csv')



