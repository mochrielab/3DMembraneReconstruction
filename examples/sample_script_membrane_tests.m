% script for mamalian cell testing
% this is a script example to show how to analyze mamlian nucleus only
% using script


%% setting up and load movie
clear all;close all;clc;
addpath('./bioformats');
% select movie file
% movie=CellVision3D.Movie('sample_image_doubleparticle.TIF');

[file,dirpath] = uigetfile('*.tif');
%%
movie=CellVision3D.Movie(fullfile(dirpath,file));

% display all possible channel types
display(CellVision3D.Channel.getChannelTypes())
% set channels
movie.setChannels('FluorescentMembrane3DSpherical','pma1f');
% set voxel value because .TIF doesn't contain it
movie.pix2um = 0.065;
movie.vox2um=0.065;
movie.sizeZ = 101;
movie.numframes = 1;
% load movie to RAM
% function override(obj)
%     obj.sizeZ = 101;
%     obj.numstacks = 101;
%     obj.numframes = 1;
% end
movie.load();
%%

%% initialize channel
% get channel
% % channel = movie.getChannel(channellabel);
% % % set the size of object to 100
% % channel.lobject=3;
% % % reset peak threshold, some of the particles are really dim,
% % channel.peakthreshold = .1;
% % % reset minimum distance between particles
% % channel.mindist = 3;
% % % initialize the movie
% % results = channel.init(1);
% % % preview channel
% % channel.view();
% for membrane - not really lacO
channel1 = movie.getChannel(1);
channel1.lobject = 100;
channel1.setMode('thresholding')

% initialize the channel
contours = channel1.init(1);
% preview channel
channel1.view();
%%
movie.getChannel('pma1f').convert2gradient()

%% construct cell
% construct the cell only by membrane
cells = CellVision3D.CellConstructor.constructCellsByMembrane(contours);
% % set filters to only select cells with two lacO found
% filter=CellVision3D.CellFilter(channellabel);
% % apply filtter
% cells=filter.applyFilter(cells);
% % view result
movie.view(cells);
%% reconstruct cell
% cells=cells(1:5); % only choose first 2 cells to make it faster for testing
% run with images (slow)
f=figure('Position',[50 50 1200 600]);
channel1.run(cells,[],f);
% run without images (much faster)
% channel.run(cells);
%% run the analysis based on constructed cells
% run particle distance analysis
% CellVision3D.CellAnalyzer.extractParticlePairDistance(cells, channellabel)
% CellVision3D.CellAnalyzer.extractParticleNumber(cells, channellabel)
% CellVision3D.CellAnalyzer.extractParticleSize(cells, channellabel)
% CellVision3D.CellAnalyzer.extractParticleIntensity(cells, channellabel)
%% save the result
% save the full result to the directory of the movie files
isoverride = 1;
movie.save(isoverride);
% export only the runned analysis
cells.exportCSV('test.csv')

%%

for icell =1:5
    p.vertices = cells(icell).contours.vertices{1};
    p.faces = cells(icell).contours.faces{1};
    clf
    edgecolor='none';
    facealpha='1';
    edgealpha='1';
    h=patch(p,'FaceColor',facecolor,...
        'FaceAlpha',facealpha,'EdgeColor',edgecolor,...
        'EdgeAlpha',edgealpha);
    view(3);
    camlight;
    lighting gouraud;
    axis image;
    pause
end
