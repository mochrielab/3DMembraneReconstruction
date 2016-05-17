function  extractParticlePairDistance(cells,channellabel)
% extract particle distance in the channel with 'channellabel'
% if only 1 particle is found, the distance = 0
% if 0 or more than 2 particles are found, the distance = nan;
% the results are saved in the cells.particles.userdata.particle_pair_pairdistance
% 3/26/2016 Yao Zhao

%%
for icell=1:length(cells)
    % get particles
    particles = cells(icell).particles;
    % get particles in the channel specified by channellabel
    particles=particles(strcmp({particles.label},channellabel));
    
    % numparticles
    numparticles=length(particles);
    if numparticles == 0
    elseif numparticles > 2
        dist=nan(particles(1).numframes,1);
        particles.setUserData('particle_pair_distance',dist);
    elseif numparticles ==1
        dist=zeros(particles(1).numframes,1);
        particles.setUserData('particle_pair_distance',dist);
    elseif numparticles ==2
        dist=CellVision3D.Math.Geometry.getDistance...
            (particles(1).positions,particles(2).positions,particles(1).zxr)...
            *particles(1).pix2um;
        particles.setUserData('particle_pair_distance',dist);
    end
    
end


end

