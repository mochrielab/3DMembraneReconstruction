% membrane analysis
clear all;
close all;
clc
import CellVision3D.*
import CellVision3D.filesystem.*
% initialize
global datapath;
global codepath;
filesystem.SetupUserPath;
dirpath=fullfile(datapath,'Movie for analysis\nuclei');
[ fns,filepaths,filenames ] = GetFilesWithinFolder( dirpath, '.dv' );
savedir=fullfile(datapath,'Movie for analysis\nuclei');


%% select initial for all movies
for ifile=1:length(fns)
    %% load movie and set channel
    ifile=1
    obj=Movie(fullfile(datapath,fns{ifile}));
    obj.setChannels('FluorescentMembrane3D','cut11');
    obj.load(100);
    obj.getChannel('cut11').setIlluminationcorrection(dirpath);
    %% segment the image based on first stack
    contours=obj.getChannel('cut11').init(1);
    obj.getChannel(1).run(contours);

    
end


