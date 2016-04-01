function [  ] = updateRadiusParam( obj, radius )
%automatically decide and intialize radius parameters based a given 2d segment
% output, segment output is genrerated by the sgementation functions, it
% has a format of out.Area plus other attributes

% radius = sqrt([out.Area]/pi);
minradius=min(radius);
maxradius=max(radius);
rmin = round(max(1, min(minradius-5,minradius*.7)));
rmax = round(max(maxradius+5,maxradius*1.3));
% if rmax - rmin < 20
%     rstep = .3;
% elseif rmax - rmin < 30
%     rstep = .5;
% else
%     rstep =1;
% end
rstep = .3;%(rmax-rmin)/40;

obj.rmin=rmin;
obj.rmax=rmax;
obj.rstep = rstep;
% obj.ndivision=3;%floor(log(mean(radius)/10)/log(2))+3;
end

