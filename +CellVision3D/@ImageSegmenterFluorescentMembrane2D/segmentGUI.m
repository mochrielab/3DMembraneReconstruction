function out=segmentGUI(obj,im)
% segment a 2d fluorescent image using canny edge detection
% will pop up a window for manual search for the best parameters
% 10/5/2016 Yao Zhao

%%
import CellVision3D.*
lnoise=obj.lnoise;
lobject=obj.lobject;
% calcualte linear background
im=Image2D.removeLinearBackground(im);
% bandpass filter to remove background
bimg=Image2D.bpass(im,lnoise,lobject);

[ out ] = guiselector.cellfinderfluorescent2Dgui (bimg);


end