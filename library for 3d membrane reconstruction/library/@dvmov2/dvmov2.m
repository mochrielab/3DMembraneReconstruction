classdef dvmov2 < dvmov
    %load movie
    properties
        movp
    end
    
    properties (Hidden=true)
    end
    
    properties (Dependent)
    end
    
    methods
        
        function obj=dvmov2(varargin)
            obj=obj@dvmov(varargin{1});
        end
        
        function delete(obj)
        end
        
        function img=grabp(obj,iframe,istack)
            img=double(obj.movp{istack+obj.numstacks*(iframe-1)});
        end
        
        function img=grab3p(obj,iframe)
            img=zeros(obj.sizeY,obj.sizeX,obj.sizeZ);
            for istack=1:obj.numstacks
                img(:,:,istack)=double(obj.movp{istack+obj.numstacks*(iframe-1)});
            end
        end
        
        function img=projp(obj,iframe)
            img=0;
            for i=1:obj.numstacks
                img=img+double(obj.movp{i+obj.numstacks*(iframe-1)});
            end
            img=img/obj.numstacks;
        end
        
        function loadmovie(obj,varargin)
            display('load movie overload for superclass, mod: 1,intercleave, 2,block');
            loadmovie@dvmov(obj);
            
            if nargin==1
                mod=1;
            elseif nargin==2
                mod=varargin{1};
            end
            
            if mod==2
            ml=length(obj.mov);
            obj.movp=obj.mov(1:ml/2);
            obj.mov=obj.mov(ml/2+1:end);
            elseif mod==1
            obj.movp=obj.mov(2:2:end);
            obj.mov=obj.mov(1:2:end);
            else
                error(['mod ',str2double(mod),' not an option']);
            end
        end
        
        function save_contour(np)
            display('save_contour overload for superclass');
            savefile=fullfile(np.path,[np.filename,'.mat']);
            mov=np.mov;
            movp=np.movp;
            np.mov=[];
            np.movp=[];
            save(savefile,'np');
            np.mov=mov;
            np.movp=movp;
        end
        
    end
    
end
