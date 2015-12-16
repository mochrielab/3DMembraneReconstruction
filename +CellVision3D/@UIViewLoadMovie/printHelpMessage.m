function [  ] = printHelpMessage( obj )
% print help message
% 12/14/2015 Yao Zhao

obj.print('current step ----------------------------');
obj.print('');
obj.print('Please enter or select the movie to be analyzed');
obj.print('');
obj.print('Please select number of channels of the movie file');
obj.print('');
obj.print('Please select the type of each channel');
obj.print('Only three types are currently enabled');
obj.print('');
obj.print('BrightfieldContour3D: cell contours from the brightfield image');
obj.print('');
obj.print('FluorescentMembrane3D: membrane contours from the fluorescent image');
obj.print('');
obj.print('FluorescentParticle3D: particle localizations from the fluorescent image');
obj.print('');
obj.print('Please enter a label of each channel for your reference');
obj.print('');
obj.print('Next step --------------------------------');
obj.print('');
obj.print('Load Movie');


end

