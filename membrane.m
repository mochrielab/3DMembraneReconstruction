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
    %%
    ifile=1
    obj=Movie(fullfile(datapath,fns{ifile}));
    obj.setChannels('FluorescentMembrane3D','cut11');
    obj.load(100);
    obj.getChannel('cut11').setIlluminationcorrection(dirpath);
    image=obj.getChannel('cut11').grabProjection(1);
    %%
    image3=obj.getChannel('cut11').grabImage3D(1);
    sg=ImageSegmenterFluorecentMembrane3DSphere();
    out=sg.segment(image3);
    %% find contours
    contours=obj.getChannel('cell').init(1);
    %% find particles
    obj.getChannel('lacO').setParam('zxr',obj.zxr,'lnoise',.1,...
        'lobject',5,'peakthreshold',.3,'fitwindow',15);
    particles1=obj.getChannel('lacO').init(1);
    %% find particles
    obj.getChannel('SPB').setParam('zxr',obj.zxr,'lnoise',.1,...
        'lobject',5,'peakthreshold',.3,'fitwindow',15);
    particles2=obj.getChannel('SPB').init(1);
    %% construct cells
    cells=Cell.constructCellsByContoursParticles(contours, particles1,particles2);
    filter=CellFilter('lacO','particlenumber',[1,1],'SPB','particlenumber',[1,1]);
    cells=filter.applyFilter(cells);
%     filter.setParam;
    cells.plot(0,obj.getChannel('cell').grabProjection(1));    
    %% save
    obj.setParam('cells',cells);
    obj.save(1);

end


    %% fit particles
%% process movie
[ fnsmat,~,~ ] = GetFilesWithinFolder( dirpath,'.mat' );
for ifile=1:length(fnsmat)
    %       singleworker(fnsmat{ifile});
    load(fullfile(datapath,fnsmat{ifile}));
    obj.load()
    obj.setParam('pix2um',0.16);
    obj.getChannel('SPB').run(obj.cells);
    obj.getChannel('lacO').run(obj.cells);
    obj.save(1);
end
