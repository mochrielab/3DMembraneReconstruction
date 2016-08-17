function  extractParticleNumber(cells, channellabel)
% extract particle number in the channel with 'channellabel'
% the results are saved in the cells.particles.userdata.particle_number
% 8/15/2016 Yao Zhao

%%
for icell=1:length(cells)
    % get particles
    particles = cells(icell).particles;
    % get particles in the channel specified by channellabel
    particles=particles(strcmp({particles.label},channellabel));
    % numparticles
    numparticles=length(particles);
    particles.setUserData('particle_number', numparticles);
end


end

