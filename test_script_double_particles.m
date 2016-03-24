% script for mamalian cell testing
% this is a script example to show how to analyze mamlian nucleus only
% using script


%% setting up and load movie
% select movie file
movie=CellVision3D.Movie('sample_image_doubleparticle.TIF');
% set channels
label='lacO';
movie.setChannels('FluorescentParticle3D',label);
% set voxel value because .TIF doesn't contain it
movie.vox2um=0.2;
% load movie to RAM
movie.load();
%% initialize channel
% get channel
channel = movie.getChannel(label);
% set the size of object to 100
channel.lobject=3;
% initialize the movie 
results = channel.init(1);
% reset peak threshold
channel.peakthreshold = .1;
% reset minimum distance between particles
channel.mindist = 3;
% preview channel
channel.view();
%% construct cell 
% construct the cell only by membrane
cells = CellVision3D.CellConstructor.constructCellsByParticles(results);
%% analyze cell
channel.run(cells,@(x)1,[]);
% run the analysis based on constructed cells
% channel.run(cells)