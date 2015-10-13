classdef nucmem3 < dvmov
   %chromotin motion correlation analysis
  
    properties
        num_nuc %% number of nuclei
        nuclei %% nuclei data
        wsize=25;
        continuefrom_frame=1;
        orientation %% orientation of nuclei
        celllength %%
        cellwidth %%
        trj %% trajectories of fluctuation detected
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
        % cell info vector
        cpts4
    end
    
    
    methods
        function obj=nucmem3(varargin)
            obj=obj@dvmov(varargin{1});
            
        end
        
        function delete(obj)

        end    
        
        save_contour(obj,varargin);
        load_contour(obj);
        obj=choose_endframe(obj);
        obj=get_centroid_firstframe(obj);
        obj=initialize(obj,varargin);
        obj=process_singleframe(obj,iframe);
        obj=process_singleframe2(obj,iframe);
        obj=process_allframes(obj);
        obj=remove_badcentroid(obj,iframe);
        obj=remove_badcontour(obj,iframe);
        obj=centralband_all(obj);
        obj=correct_drift(obj,varargin);
        obj=pickorientation(obj);
        f=display_contour(obj);
        obj=detect_fluctuation(obj);
    end
    
end

