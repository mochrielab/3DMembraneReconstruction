% % script for mamalian cell testing of a movie
% % this is a script example to show how to analyze mamlian nucleus only
% % using script
% 
% 
% %% setting up and load movie
% clear all; close all; clc
% % select movie file
% movie=CellVision3D.Movie('sample_image_mamalian2.dv');
% 
% % set channels
% label='mamalian membrane';
% movie.setChannels('FluorescentMembrane3D',label);
% movie.pix2um=0.266;
% % load movie to RAM
% movie.load();
% % initialize channel
% % get channel
% channel = movie.getChannel(label);
% 
% 
% %%
% % get the first image
% clc
% img3= channel.grabImage3D(1);
% % img3=CellVision3D.Image3D.crop(img3,[50 280 30 250 1 size(img3,3)]);
% sg = CellVision3D.ImageSegmenterFluorescentMembrane3D();
% sg.setParam('zxr',channel.zxr);
% sg.lobject=50;
% sg.lnoise=.5;
% sg.binxy=2;
% sg.binz=4;
% %  ps=sg.segmentLarge(img3);
% %%
% % initialize the movie 
% contours = channel.init(1);
% % view the result
% channel.view();
% 
% %% construct cell 
% % % construct the cell only by membrane
% % cells = CellVision3D.Cell.constructCellsByMembrane(contours);
% % %% analyze cell
% % % run the analysis based on constructed cells
% % channel.run(cells,@(x)1,[]);
