%initial movie
clc
clear all;
close all;
filename='sample_image.dv';
np=mempar3(filename);
np.loadmovie;
%% image segmentation
np.focusplane=round((1+np.numstacks)/2);
np.th=.3;
np.wsize=31;
display('close image if you are satisfied');
np.get_centroid_firstframe;
np.get_zcenter_firstframe;
np.get_particle_firstframe;
np.remove_badcentroid(1);
np.endframe=1;
np.initialize;
close all;
%% reconstruct 3d contours for each nuclei and track particles
psfparam.sigdiff=1.2;
np.psfparam=psfparam;
for repeat=1:4
    np.process_singleframe(1);
end
np.psfparam=psfparam;
np.process_singleframe_particle(1);
np.getmempardist
np.postanalysis;
np.decide_double;
warning off;
np.save_contour;

