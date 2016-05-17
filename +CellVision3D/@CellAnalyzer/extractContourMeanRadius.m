function extractContourMeanRadius(cells,contourchannellabel)
% extract the mean radius in contours in 'contourchannellabel'
% the results are saved in the cells.contours.userdata.mean_radius
% 3/26/2016 Yao Zhao

for icell=1:length(cells)
    % get contours
    contours =cells(icell).contours;
    contours=contours(strcmp({contours.label},contourchannellabel));

    % number contours
       
        for iparticle=1:numparticles
            for iframe =1:numframes
                dist=CellVision3D.Math.Geometry.getPointSurfaceDistance(...
                    particles(iparticle).positions(iframe,:),...
                    contours(1).vertices{iframe},...
                    contours(1).faces{iframe},contours(1).zxr);
            end
        end
        particles.setUserData('particle_contour_distance',dist);
    
end




end

