% script for mamalian cell testing of a movie
% this is a script example to show how to analyze mamlian nucleus only
% using script


%% setting up and load movie
% select movie file
movie=CellVision3D.Movie('sample_image_mamalian2.dv');

% set channels
label='mamalian membrane';
movie.setChannels('FluorescentMembrane3D',label);
% load movie to RAM
movie.load();
%% initialize channel
% get channel
channel = movie.getChannel(label);
% set the size of object to 100
channel.lobject=30;
% initialize the movie 
contours = channel.init(1);
% view the result
channel.view();

%% construct cell 
% % construct the cell only by membrane
% cells = CellVision3D.Cell.constructCellsByMembrane(contours);
% %% analyze cell
% % run the analysis based on constructed cells
% channel.run(cells,@(x)1,[]);
