function  extractParticleIntensity(cells, channellabel)
% extract particle intensity in the channel with 'channellabel'
% the results are saved in the
% cells.particles.userdata.particle_intensity as an array [I1, I2, ...]
% 8/16/2016 Yao Zhao

%%
for icell=1:length(cells)
    % get particles
    particles = cells(icell).particles;
    % get particles in the channel specified by channellabel
    particles=particles(strcmp({particles.label},channellabel));
    
    % numparticles
    numparticles=length(particles);
    
    % intensity array by calculating the particle brightness mean
    for iparticle = 1:numparticles
        % set particle intensities
        particles(iparticle).setUserData('particle_intensity',...
            (particles(iparticle).brightness));
    end
end


end

