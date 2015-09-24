classdef mitosis < dvmov
   %chromotin motion correlation analysis
  
    properties
        num_nuc %% number of nuclei
        nuclei %% nuclei data
        wsize=25;
        continuefrom_frame=1;
    end
    properties (Hidden=true)
        focusplane=5;
        th=0.3;
        zexpand

        %radius range
        rs
        %triangulation param
        points
        faces
        edges
        neighbors
        %current cnter
        cnt_tmp
        %interped 2d matrix
        linearindex
        weights
    end
    
    
    methods
        function obj=mitosis(varargin)
            obj=obj@dvmov(varargin{1});
            
        end
        
        function delete(obj)

        end    
        
        save_contour(obj);
        load_contour(obj);
        obj=choose_endframe(obj);
        obj=get_centroid_firstframe(obj);
        obj=initialize(obj,varargin);
        obj=process_singleframe(obj,iframe);
        obj=process_allframes(obj);
        obj=remove_badcentroid(obj,iframe);
        obj=remove_badcontour(obj,iframe);
        f=display_contour(obj);
        
    end
    
end

