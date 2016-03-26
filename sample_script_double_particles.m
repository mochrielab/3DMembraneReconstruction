% script for mamalian cell testing
% this is a script example to show how to analyze mamlian nucleus only
% using script


%% setting up and load movie
clear all;close all;clc;
% select movie file
movie=CellVision3D.Movie('sample_image_doubleparticle.TIF');
% set channels
channellabel='lacO';
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
% reset peak threshold
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
% set filter
filter=CellVision3D.CellFilter(channellabel,'FluorescentParticle3D_number',[2 2]);
% apply filtter
cells=filter.applyFilter(cells);
% view result
movie.view(cells);
%% reconstruct cell
cells=cells(1:2); % only choose first 2 cells to make it faster for testing
f=figure;
channel.run(cells,[],f);
%% run the analysis based on constructed cells
% run particle distance analysis
CellVision3D.CellAnalyzer.extractParticlePairDistance(cells,'lacO')

%%
data.movie=movie;
data.cells=cells;
ui=CellVision3D.UIViewAnalyze(data);

% ui.next();

