function  extractParticleSize(cells, channellabel)
% extract particle size in the channel with 'channellabel'
% the results are saved in the
% cells.particles.userdata.particle_size as an array [s1, s2, ...]
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
        particles(iparticle).setUserData('particle_size',...
            mean(particles(iparticle).sigmas(:,1)));
    end
        
end


end

