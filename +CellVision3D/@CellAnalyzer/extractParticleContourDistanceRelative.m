function extractParticleContourDistanceRelative(cells,particlechannellabel,contourchannellabel)
% extract distance between particles in 'particlechannellabel' and
% contours in 'contourchannellabel' in a relative scale to the mean contour
% radius
% the results are saved in the
% cells.particles.userdata.particle_contour_distance_relative
% 3/26/2016 Yao Zhao

% call method to calculate particle contour distance
CellVision3D.CellAnalyzer.extractParticleContourDistance(cells,particlechannellabel,contourchannellabel)
% call method to calculate mean radius of contour
CellVision3D.CellAnalyzer.extractContourMeanRadius(cells,contourchannellabel)


% loop through cells
for icell=1:length(cells)
    % get particles
    particles = cells(icell).particles;
    % get particles in the channel specified by channellabel
    particles=particles(strcmp({particles.label},particlechannellabel));
    % get contours
    contours =cells(icell).contours;
    contours=contours(strcmp({contours.label},contourchannellabel));
    % calculate relative distance
    % numparticles
    numparticles=length(particles);
    % number contours
    numcontours=length(contours);
    if numparticles == 0
    elseif numcontours ==0 || numcontours>1
        dist=nan(particles(1).numframes,1);
        particles.setUserData('particle_contour_distance',dist);
    else
        % num frames
        for iparticle=1:numparticles
            particles(iparticle).setUserData('particle_contour_distance_relative',...
                particles(iparticle).userdata.particle_contour_distance/...
                contours(1).userdata.mean_radius);
        end
    end
end




end

