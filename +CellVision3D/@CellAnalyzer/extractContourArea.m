function extractContourArea(cells,contourchannellabel)
% extract the area in contours in 'contourchannellabel'
% the results are saved in the cells.contours.userdata.area
% the unit is converted to microns^2
% 9/15/2016 Yao Zhao

for icell=1:length(cells)
    % get contours
    contours =cells(icell).contours;
    contours=contours(strcmp({contours.label},contourchannellabel));
    numcontours = length(contours);
    % number contours
    for icontour=1:numcontours
%         radii = zeros(contours(icontour).numframes,1);
        areas =contours(icontour).getArea...
            *contours(icontour).pix2um^2;
        contours(icontour).setUserData('area',areas);
    end
    
end

end

