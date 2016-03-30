classdef Channel < CellVision3D.HObject  & matlab.mixin.Heterogeneous & ...
        CellVision3D.Object3D
    % microscope channel 
    % 11/17/2015
    
    
    properties (SetAccess = public)
        label
        type
        numframes
        numstacks
        sizeX
        sizeY
        sizeZ
    end
    
    properties (SetAccess = protected)
        data
        illuminationcorrection
    end
    
    methods
        %constructor
        function obj=Channel(label,type)
            obj.label=label;
            obj.type=type;
        end
        %set movie
        function load(obj,data,varargin)
            obj.data=data;
            if nargin>=3
                movie=varargin{1};
                obj.numframes=movie.numframes;
                obj.numstacks=movie.numstacks;
                obj.sizeY=movie.sizeY;
                obj.sizeX=movie.sizeX;
                obj.sizeZ=movie.sizeZ;
                obj.zxr=movie.zxr;
            end
        end
        %grab image
        function img=grabImage(obj,iframe,istack)
            img=double(obj.data{istack+obj.numstacks*(iframe-1)});
            if ~isempty(obj.illuminationcorrection)
                img=img./obj.illuminationcorrection;
            end
        end
        %grab image 3d
        function img=grabImage3D(obj,iframe)
            img=zeros(obj.sizeY,obj.sizeX,obj.sizeZ);
            for istack=1:obj.numstacks
                img(:,:,istack)=double(obj.data{istack+obj.numstacks*(iframe-1)});
                if ~isempty(obj.illuminationcorrection)
                    img(:,:,istack)=img(:,:,istack)./obj.illuminationcorrection;
                end
            end
        end
        % grab image projection
        function img=grabProjection(obj,iframe)
            img=zeros(obj.sizeY,obj.sizeX);
            for istack=1:obj.numstacks
                img=img+double(obj.data{istack+obj.numstacks*(iframe-1)});
            end
            img=img/obj.numstacks;
            if ~isempty(obj.illuminationcorrection)
                img=img./obj.illuminationcorrection;
            end
        end
        % set illumination correction
        function setIlluminationcorrection(obj,filepath)
            % search for illumination
            pathtmp=(fullfile(filepath,'illumination.mat'));
            if ~exist(pathtmp,'file')
                throw(MException('Channel:UnFoundIllu',...
                    'cant find illumination.mat'));
            else
                load(pathtmp);
                obj.illuminationcorrection=illumination;
            end
        end
        % temporarily unload movie for saving
        function data=unloadData(obj)
            data=obj.data;
            obj.data=[];
        end
        % view projection
        [  ] = viewProjection(obj )
        
        % check if some parameter doesnt belong to channel
        array = isNonChannelParam( obj )
    end
    
    methods( Abstract)
    end
    
    methods (Access=public, Static)
     [ channeltypes, channelclassnames,descriptions ] = getChannelTypes(  )
    end
end

