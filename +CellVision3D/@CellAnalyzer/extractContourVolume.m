function extractContourVolume(cells,contourchannellabel)
% extract the volume in contours in 'contourchannellabel'
% the results are saved in the cells.contours.userdata.volume
% 3/26/2016 Yao Zhao

for icell=1:length(cells)
    % get contours
    contours =cells(icell).contours;
    contours=contours(strcmp({contours.label},contourchannellabel));
    numcontours = length(contours);
    % number contours
    for icontour=1:numcontours
%         radii = zeros(contours(icontour).numframes,1);
        vols =contours(icontour).getVolume...
            *contours(icontour).pix2um^3;
        contours(icontour).setUserData('volume',vols);
    end
    
end

end

