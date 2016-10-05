function out=segment(obj,im)
% segment use different method
% 10/5/2016 Yao Zhao

% out is the regionprop object

switch obj.mode
    case 'thresholding'
        display('use mode thresholding');
        [ out ] = obj.segmentGUI(im);
    case 'automatic'
        [ out ] = obj.segmentAuto(im);
        display('use mode automatic');
    otherwise
        error('mode not supported');
end


end