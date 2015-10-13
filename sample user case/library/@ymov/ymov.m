classdef ymov < handle
    % a universal movie class for microscope data analysis
    % 3/21/2015
    % Yao Zhao
    
    %load movie
    properties
        % file system
        filename
        path
        
        % microscope data
        pix
        vox
        aberation=1.33/1.516;
        
        % analysis parameters
        startframe=1
        endframe
        wsize=31 % sub window size, depended on objects
        particleparam=struct('lnoise',.5,'lobject',5,...
            'peakthreshold',.2,'bordercut',[20 20 2],...
            'maxsigma',3,'minsigma',.5,...
            'maxpeak',1.2,'minpeak',.2,'maxdisp',5);
        driftparam=struct('order',1,'fNorm',.02);% order of filter -> lowest is 1, highest is whatever
        filterparam % filter parameter of each channel 
        isdone=0
        
        % imaging condition
        sizeX
        sizeY
        sizeZ
        numstacks
        numframes
        illuminationcorrection
        psfparam
        
        % data information
        numchannels=1 % support maximum 4
        % possble types are bf, fm,fp
        channeltypes={'bf'}  % record the type of each channel
        channelnames ={'1'}
        
        % picture info
        picturefilename
        numpictures
        
        % data from first image
        cellcontour_ff % cell contour from the bright field image
        nucleicontour_ff % nuclei contour from fluroescent image
        particle_ff % particle cnts from the first image
        membrane_ff % membrane data from the first image

        % main data for the movie
        data
        numdata
        drift
        result
    end
    
    properties (Hidden=true)
        % movie
        omeMeta
        mov
        fformat
        % pictures
        pictures
    end
    
    properties (Dependent)
        filein
        zxr
    end
    
    
    methods
        %initialize loadmovie from file or select movie to load
        function obj=ymov(varargin)
            global datapath;
            if isempty(varargin)
                [obj.filename,obj.path]=uigetfile(fullfile(obj.path,'*.dv'),...
                    'Please choose file to analyze');
            elseif length(varargin)==1 && exist(fullfile(datapath,varargin{1}))
                [obj.path,obj.filename,ext]=fileparts(varargin{1});
                if strcmp(ext,'.dv')==0
                    warning('dv file needed');
                end
            elseif ~exist(fullfile(datapath,varargin{1}))
                error('file doesn''t exist');
            else
                error('wrong file input type');
            end
        end
        
        % basic movie and image
        [ obj ] = SetChannel( obj, varargin )
        [ obj ] = LoadMovie( obj , varargin )
        [ img ] = GrabImage3D( obj, channelname, iframe)
        [ img ] = GrabImage( obj, channelname, iframe, istack)
        [ img ] = GrabProjection( obj, channelname, iframe)
        [ obj ] = AddReferenceImage( obj, picturefilename, picture_index)
        [ obj ] = Save( obj, varargin )
        [ obj ] = GetPSF( obj, varargin );

        % first image process
        [ obj ] = FirstImageContourBF( obj,tag,id )
        [ obj ] = FirstImageContourFluo( obj, tag, id )
        [ obj ] = FirstFrameParticle( obj, id, varargin )

        % data processing
        [ obj ] = InitializeData( obj, mainchannel, varargin)
        [ obj ] = GetContourProperties( obj )
        [ obj ] = DriftCorrect( obj, mod, varargin )
        [ obj ] = TrackParticle( obj, varargin );
        
        % filter
        [ obj ] = SetFilterParameter( obj, varargin )
        [ in ] = Filter_RCM( obj )
        
        % data analyze
         [ obj ] = AnalyzeParticleCorrelation( obj, channels, varargin)

        % show plots
        [ obj ] = ShowParticleTracks( obj, varargin )
        [ obj ] = ShowCellSelection( obj, varargin )
        [ obj ] = ShowDirft( obj)
        [ obj ] = ShowParticleCorrelation( obj, channels, varargin)

        
        %dependent properties
        function filein=get.filein(obj)
            global datapath;
            filein=fullfile(datapath,obj.path,[obj.filename,'.dv']);
        end
        function zxr = get.zxr(obj)
            zxr=obj.vox/obj.pix*obj.aberation;
        end
        
    end
    
end
