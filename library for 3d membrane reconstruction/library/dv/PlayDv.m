function [] = PlayDv( mov , sec)
%Play Dv movie
%   Detailed explanation goes here
f=figure;hold on;
for i=1:length(mov)
    clf;
    imagesc(mov{i});axis image;colormap gray;hold on;
    pause(sec);
end
end

