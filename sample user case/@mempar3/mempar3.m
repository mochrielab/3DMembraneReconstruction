classdef mempar3 < nucmem3
    %chromotin motion correlation analysis
    
    properties
        movp
        pcnt
        particle
        pts
        goodpair
        psfparam
    end
    
    methods
        function obj=mempar3(varargin)
            obj=obj@nucmem3(varargin{1});
            % intensitys
            ints=zeros(1,obj.numstacks);
            for istack=1:obj.numstacks
                ints(istack)=max(max(obj.grab(1,istack)));
            end
            [~,obj.focusplane]=max(ints);
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
        
        function loadmovie(obj)
            display('load movie overload for superclass');
            loadmovie@nucmem3(obj);
            ml=length(obj.mov);
            if ml == 2*obj.numstacks
                obj.movp=obj.mov(1:ml/2);
                obj.mov=obj.mov(ml/2+1:end);
            elseif ml == 3*obj.numstacks
                obj.movp=obj.mov(1:ml/3);
                obj.mov=obj.mov(ml/3+1:ml/3*2);
            else
                ml
                obj.numstacks
                error('unsupported data type');
            end
        end
        
        function initialize(obj)
            display('initialize overload for superclass');
            initialize@nucmem3(obj)
            obj.particle=repmat({[]},obj.endframe,obj.num_nuc);
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
        remove_badcentroid(obj,iframe)
        process_singleframe_particle(obj,iframe)
        differentiate_single_vs_double(obj);
        get_centroid_firstframe(obj);
        get_zcenter_firstframe(obj);
        getmempardist(obj);
        postanalysis(obj);
        decide_double(obj);
    end
end

