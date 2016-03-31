% script for mamalian cell testing
% this is a script example to show how to analyze mamlian nucleus only
% mamalian cells should not be constructed using spherical type 
% because they are usually very flat
% using script


%% setting up and load movie
clear all;close all;clc;
% select movie file
movie=CellVision3D.Movie('sample_image_mamalian.dv');
% set channels
label='mamalian membrane';
movie.setChannels('FluorescentMembrane3DSpherical',label);
% reset pix2um ... wrong values selected
movie.pix2um=0.16/2*3;
% load movie to RAM
movie.load();
%% initialize channel
% get channel
channel = movie.getChannel(label);
% set the size of object to 100
channel.lobject=100;
% initialize the movie 
contours = channel.init(1);
% view
channel.view();
%% construct cell 
% construct the cell only by membrane
cells = CellVision3D.CellConstructor.constructCellsByMembrane(contours);
% view result
movie.view(cells);
%% analyze cell
% run the analysis based on constructed cells
channel.run(cells,@(x)1,[]);
