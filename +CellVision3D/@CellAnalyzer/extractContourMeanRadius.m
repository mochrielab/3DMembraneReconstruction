function extractContourMeanRadius(cells,contourchannellabel)
% extract the mean radius in contours in 'contourchannellabel'
% the results are saved in the cells.contours.userdata.mean_radius
% 3/26/2016 Yao Zhao

for icell=1:length(cells)
    % get contours
    contours =cells(icell).contours;
    contours=contours(strcmp({contours.label},contourchannellabel));
    numcontours = length(contours);
    % number contours
    for icontour=1:numcontours
%         radii = zeros(contours(icontour).numframes,1);
        radii =(contours(icontour).getVolume*3/4/pi).^(1/3) ...
                *contours(icontour).pix2um;
        contours(icontour).setUserData('mean_radius',radii);
    end
    
end

end

