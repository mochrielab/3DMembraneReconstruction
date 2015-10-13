%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DrawCircles(pk,beadsiz,color,textsiz)
%
% Summary:
%     This function maps out a circle in polar coordinates to plot with the
%     locations from pk, a vector containing x and y locations.
%
% Input:
%     pk - a vector with two columns containing x and y coordinates
%     beadsiz - size of the circle
%     color - color of the cirlce
%
% Output:
%     none
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function DrawCircles(pk,beadsiz,color,textsiz)

if length(beadsiz)==1
    beadsiz=beadsiz+zeros(size(pk(:,1)));
end

hold on;
for k = 1:size(pk,1)
    NOP = 1000;
    radius = beadsiz(k)*.5;
    THETA = linspace(0,2*pi,NOP);
    RHO = ones(1,NOP)*radius;
    [X,Y] = pol2cart(THETA,RHO);
    
    if pk(k,1) ~= 0
        x = X + pk(k,1);
        y = Y + pk(k,2);
        if size(pk,2)==2
            plot(x,y, color, 'Linewidth', 1);
        elseif size(pk,2)==3
            plot3(x,y,pk(k,3)+zeros(size(x)));
        else
            error('wrong peak size')
        end
        if textsiz>0
            text(pk(k,1)-beadsiz*.6,pk(k,2)-beadsiz*.6,int2str(k),'FontSize',textsiz,'Color',color);
        end
    end
end

end



