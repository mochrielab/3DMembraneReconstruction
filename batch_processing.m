%% 3DMembraneReconstruction Batch Processing
% Section #1

% This code processes a series of movies in parallel to allow for quicker 
% analysis. The same steps are executed here as in the GUI and
% sample_script.m. 

% Note: all movies to be processed should have the same parameters. This
% batch code will simply iterate the same parameters over each movie. 

% To run: 
% 1) Ensure all movie sets to be processed are in their own folder,
%    and these folders are in the same parent folder, and this parent
%    folder is open in the Current Folder.
% 2) Fill out and check all of the processing parameters below.
% 3) Run this section (Section #1) to load variables into Workspace.
% 4) Run Section #2 to process all the datasets together. 

% Jessica Johnston // last edited February 8, 2018.

% SET UP PROCESSING PARAMETERS - ** edit & check **

% Clear workspace, et cetera.
clear all;close all;clc;

% What type of images are to be processed? Example, '*.tif', or '*.dv'
image_type = '*.tif';

% **** CHANNELS ****

% How many channels are in image stack? 
num_channels = 4;

% Which channels are to be used for the reconstruction analysis? If yes,
% assign to '1' for particle channel and '2' for membrane channel. If not
% using channel, assign to '0'.
channel_1 = 0;
channel_2 = 0;
channel_3 = 1;
channel_4 = 2;

% **** PARTICLE ANALYSIS ****

% For one particle analysis, set to '1'; for two particle analysis, set to
% '2'; to omit this analysis altogether, set to '0'.
particle_channel = 1; 
% Designate particle name(s).
particle_name = 'loci';
% particle_name2 = 'mCherry-loci';
% Designate particle size in pixels (approximate).
particle_size = 3;

% **** MEMBRANE ANALYSIS ****

% For membrane analysis, set to '1'; to omit this, set to '0'.
membrane_channel = 1;
% Designate membrane name.
membrane_name = 'cut11';
% Designate membrane size in pixels (approximate).
membrane_size = 30;

% **** CELL CONSTRUCTION ***

% Designate how to construct the cells - by particles only, membranes only,
% or by both particles and membranes. If yes, set to '1'; if no, set to
% '0'. Only set one variable to '1'; leave other two variable as '0'.

% Construct cells only by particles:
cell_construct_particle = 0;
% Construct cells only by membranes:
cell_construct_membrane = 0;
% Construct cells by both particles and membranes:
cell_construct_membrane_particle = 1;

% How many fluorescent particles should be in each cell? Set this number as
% a means of filtering out cells with fewer/more particles.
particle_number = 1;

% **** SAVING IMAGES ****

% Show and save each reconstruction? If so, set 'show_and_save' to '1'; if
% you want to run the reconstructions without showing and saving each
% individual image (much faster overall), set to '0'.
show_and_save = 1;

%% Run all datasets in parallel. **Do not edit.**
% Section #2

% Select parent directory of movie file sets.
dirpaths = dir(fullfile('./')); % Current Folder

% Omit cached folder names.
folderidx = [];
for i = 1:length(dirpaths)
    if strncmp(dirpaths(i).name,'.',1) == 0
        folderidxtmp = i; 
    else
        folderidxtmp = [];
    end
    folderidx = [folderidx;folderidxtmp];
end

% Parfor loop to process each movie set in parallel.
parfor idir = folderidx(1):folderidx(end)
    
    % Set up and load movie
    dirpath = dirpaths(idir).name;
    files = dir(fullfile(dirpath,image_type));
    filenames = {files.name};
    ifile = 1;
    
    % Group, assign, and order channels.
    all_channels = {channel_1,channel_2,channel_3,channel_4};
    active_channels = {particle_channel,membrane_channel};
    
    channel_name = {};
    for i = 1:num_channels
        if all_channels{i} == 0
            channel_name{1,i} = 'None'; % Name the unused channels.
            channel_name{2,i} = 'None';
        elseif all_channels{i} == 1
            channel_name{1,i} = 'FluorescentParticle3D';
            channel_name{2,i} = particle_name;
        elseif all_channels{i} == 2
            channel_name{1,i} = 'FluorescentMembrane3DSpherical';
            channel_name{2,i} = membrane_name;
        end
    end
    
    %% Set channels & load movie.
    
    movie = CellVision3D.Movie(fullfile('./',dirpath,filenames{ifile}));
    % Assign file name without extension to movie_names
    [path,movie_name,ext] = fileparts(filenames{ifile});
    % Display all possible channel types
    display(CellVision3D.Channel.getChannelTypes())
    % Set channels
    movie.setChannels(channel_name{:})
    % Load movie to RAM
    movie.load();
        
    %% Initialize channel 1 - particle channel

    if particle_channel == 1 || 2
        % Get channel
        channel1 = movie.getChannel(particle_name);
        % Set the size of object (in pixels)
        channel1.lobject = particle_size;
        % Reset peak threshold if some of the particles are too dim
        channel1.peakthreshold = .3;
        % Reset minimum distance between particles
        channel1.mindist = 3;
        % Initialize the movie
        particles = channel1.init(1);
        % Preview channel
        channel1.view();
        % Save image in image folder
        saveas(gcf,fullfile('./',dirpath,...
            sprintf('%s_init_particle',movie_name)),'png')
        close
    end
        
    %% Initialize channel 2 - 2nd particle channel

    if particle_channel == 2
        % Get channel
        channel2 = movie.getChannel(particle_name2);
        % Set the size of object (in pixels)
        channel2.lobject = particle_size;
        % Reset peak threshold if some of the particles are too dim
        channel2.peakthreshold = .3;
        % Reset minimum distance between particles
        channel2.mindist = 3;
        % Initialize the movie
        particles2 = channel2.init(1);
        % Preview channel
        channel2.view();
        % Save image in image folder
        saveas(gcf,fullfile('./',dirpath,...
            sprintf('%s_init_particle2',movie_name)),'png')
        close
    end
        
    %% Initialize channel 2 - membrane channel

    if membrane_channel == 1
        % Get channel
        channel2 = movie.getChannel(membrane_name);
        % Set the size of object (in pixels)
        channel2.lobject = membrane_size;
        % Set noise level for gaussian band pass
        channel2.lnoise = 1;
        % Pad with zeros instead of same image
        channel2.padsame = false;
        % Split the cell three ways
        channel2.ndivision = 3;
        % Initialize channel
        contours = channel2.init(1);
        % Preview channel
        channel2.view();
        % Save image in image folder
        saveas(gcf,fullfile('./',dirpath,...
            sprintf('%s_init_membrane',movie_name)),'png')
        close
    end
        
        %% Initialize channel 3
        
        % get channel
%         channel3 = movie.getChannel('cell body');
% %         % set the size of object to 100
% %         channel2.lobject=3;
% %         % reset peak threshold, some of the particles are really dim,
% %         channel2.peakthreshold = .3;
% %         % reset minimum distance between particles
% %         channel2.mindist = 3;
% %         % initialize the movie
%         contour = channel3.init(1);
%         % preview channel
%         channel3.view();
        
    %% Construct cell
    % Construct cells by particle, membrane, or by particle & membrane

    if cell_construct_membrane_particle == 1
        % Construct cells by particle & membrane
        cells = ...
            CellVision3D.CellConstructor.constructCellsByMembraneParticles(...
            contours,particles);
        % Set filters to select only cells with desired particle number
        filter = CellVision3D.CellFilter(particle_name,...
            'FluorescentParticle3D_number',...
            [particle_number particle_number]);
        % Apply filter
        cells = filter.applyFilter(cells);
    elseif cell_construct_particle == 1
        % Construct cells by particle
       cells = CellVision3D.CellConstructor.constructCellsByParticles(...
           particles);
        % Set filters to select only cells with desired particle number
        filter = CellVision3D.CellFilter(particle_name,...
            'FluorescentParticle3D_number',...
            [particle_number particle_number]);
        % Apply filter
        cells = filter.applyFilter(cells);
    elseif cell_construct_membrane == 1
       cells = CellVision3D.CellConstructor.constructCellsByMembrane(...
           contours);
    elseif cell_construct_particle == 1 && particle_channel == 2
       % Construct cells by particle
       cells = CellVision3D.CellConstructor.constructCellsByParticles(...
           particles,particles2);
        % Set filters to select only cells with desired particle number
        filter = CellVision3D.CellFilter(particle_name,...
            'FluorescentParticle3D_number',...
            [particle_number particle_number]);
        % Apply filter
        cells = filter.applyFilter(cells);
    end
    % View result
    figure
    movie.view(cells);
    pause(0.1)
    % Save image in Current Folder
    saveas(gcf,fullfile('./',dirpath,...
        sprintf('%s_construct',movie_name)),'png')
    close

    %% Reconstruct cells

    % Run with images shown and saved (slower).
    if show_and_save == 1
        f = figure('Position',[50 50 1200 800]);

        % Reconstruct only particles.
        if particle_channel == 1 && membrane_channel == 0
            channel1.run(cells,[],f,dirpath,movie_name);
            close

        % Reconstruct only membranes.
        elseif membrane_channel == 1 && particle_channel == 0
            channel2.run(cells,[],f,dirpath,movie_name);
            close

        % Reconstruct both particles and membranes.
        elseif particle_channel && membrane_channel == 1
            channel1.run(cells,[],f,dirpath,movie_name);
            channel2.run(cells,[],f,dirpath,movie_name);
            close

        % Reconstruct both particle channels.
        elseif particle_channel == 2
            channel1.run(cells,[],f,dirpath,movie_name);
            channel2.run(cells,[],f,dirpath,movie_name);
            close
        end
    else
    % Run reconstruction without showing images (much faster).
    channel1.run(cells);
    channel2.run(cells); 
    end
        
    %% Analyze cells - extract measurements

    if particle_channel && membrane_channel == 1
        CellVision3D.CellAnalyzer.extractParticleContourDistance(cells,...
            particle_name,membrane_name);
        CellVision3D.CellAnalyzer.extractContourMeanRadius(cells,...
            membrane_name);
        CellVision3D.CellAnalyzer.extractContourVolume(cells,...
            membrane_name);
        CellVision3D.CellAnalyzer.extractParticleContourDistanceRelative(...
            cells,particle_name,membrane_name);
    elseif particle_channel == 2
        CellVision3D.CellAnalyzer.extractParticlePairDistance(cells,...
            particle_name,particle_name2);
    else 
        CellVision3D.CellAnalyzer.extractContourMeanRadius(cells,...
            membrane_name);
        CellVision3D.CellAnalyzer.extractContourVolume(cells,...
            membrane_name);
    end

    %% Save the measurements results.
    % Save the full result to the directory of the movie files.
    cells.exportCSV(fullfile('./',dirpath,sprintf('%s.csv',movie_name)))
    movie.save(1,[],cells);  
       
end
