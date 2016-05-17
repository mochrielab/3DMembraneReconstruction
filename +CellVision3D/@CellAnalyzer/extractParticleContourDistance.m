function extractParticleContourDistance(cells,particlechannellabel,contourchannellabel)
% extract distance between particles in 'particlechannellabel' and
% contours in 'contourchannellabel'
% the results are saved in the cells.particles.userdata.particle_contour_distance
% 3/26/2016 Yao Zhao

% loop through cells
for icell=1:length(cells)
    % get particles
    particles = cells(icell).particles;
    % get particles in the channel specified by channellabel
    particles=particles(strcmp({particles.label},particlechannellabel));
    % get contours
    contours =cells(icell).contours;
    contours=contours(strcmp({contours.label},contourchannellabel));
    
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
            numframes=particles(iparticle).numframes;
            dist=zeros(numframes,1);
            for iframe =1:numframes
                dist(iframe)=CellVision3D.Math.Geometry.getPointSurfaceDistance(...
                    particles(iparticle).positions(iframe,:),...
                    contours(1).vertices{iframe},...
                    contours(1).faces{iframe},contours(1).zxr)...
                    *particles(1).pix2um;
            end
            particles(iparticle).setUserData('particle_contour_distance',dist);
        end
    end
    
end




end

