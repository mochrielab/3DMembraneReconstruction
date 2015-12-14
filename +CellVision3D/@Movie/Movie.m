classdef Movie < CellVision3D.HObject
    % a universal movie class for microscope data analysis
    % 3/21/2015
    % Yao Zhao
    
        
    properties (Constant)
        channel_options = {'BrightfieldContour3D','FluorescentParticle3D',...
            'FluorescentMembrane3D'}
    end
    
    %load movie
    properties (SetAccess = public)
        % file system
        filename % file name
        path % file path
        extension % file extention
        
        % microscope data
        pix2um  % pixel 2 microns
        vox2um  % voxel height
        aberation=1 % aberation correction
        
        % movie information
        numstacks % number of stacks
        numframes % number of frames

        % imaging condition
        sizeX % image size x
        sizeY % image size y
        sizeZ % image size Y
                
        % data information
        numchannels % number of channels
        channels % channel handles
        
        % extracted data
        cells
        particles
    end
    
    properties (Hidden=true)
        % movie
%         fformat
    end
    
    properties (Dependent)
        filein
        zxr
    end
    
    
    methods
        %initialize loadmovie from file or select movie to load
        function obj=Movie(varargin)
            % popout ui for file selection
            if isempty(varargin)
                [obj.filename,obj.path]=uigetfile(pwd,...
                    'Please choose file to analyze');
            % use file in the path
            elseif length(varargin)==1 && exist(varargin{1},'file')
                [obj.path,obj.filename,obj.extension]=fileparts(varargin{1});
            elseif length(varargin)==1
                throw(MException('Movie:CantFindFile','can not find file'));
            else
                throw(MException('Movie:Unsupported','unsupported options'));
            end
                        
        end
                
        % basic movie and image
        [ obj ] = setChannels( obj, varargin )
        [ obj ] = load( obj , varargin )
        [ obj ] = getChannel( obj , label )
        [ obj ] = save( obj,isoverride )
                        
        %dependent properties
        function filein=get.filein(obj)
            filein=fullfile(obj.path,[obj.filename,obj.extension]);
        end
        function zxr = get.zxr(obj)
            zxr=obj.vox2um/obj.pix2um*obj.aberation;
        end
    end
    
    methods (Static)
        [  ] = view3D( wimg3,varargin )
    end
    
    
end
