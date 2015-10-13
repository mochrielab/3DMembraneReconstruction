function [ obj ] = ShowDrift( obj )
% plot the drift of this movie
drift=obj.drift;
plot3(drift(:,1),drift(:,2),drift(:,3),'b'); hold on;
axis equal;


end

