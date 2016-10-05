function [  ] = exportCSV( cells,filename )
% export the result to excel
% 3/27/2016 Yao Zhao

%%
% open file
file=fopen(filename,'w');

% titles
% header data
fprintf(file,'Cell Id,');
fprintf(file,'Channel Label,');
fprintf(file,'frame ID,');

% header data cell section
celluserdatafieldnames = cells.getUserDataFieldNames();
numcelluserdata = length(celluserdatafieldnames);
% print cell userdata field
for ii=1:numcelluserdata
    switch celluserdatafieldnames{ii}
        otherwise
            ext='';
    end
    fprintf(file,[celluserdatafieldnames{ii},ext,',']);
end

%header data contour section
contours=[cells.contours];
if ~isempty(contours)
    contouruserdatafilednames = getUserDataFieldNames(contours);
else
    contouruserdatafilednames = [];
end
numcontouruserdata = length(contouruserdatafilednames);
% print cell userdata
for ii=1:numcontouruserdata
    switch contouruserdatafilednames{ii}
        case 'mean_radius'
            ext = ' (um)';
        case 'volume'
            ext = ' (um^3)';
        otherwise
            ext='';
    end
    fprintf(file,[contouruserdatafilednames{ii},ext,',']);
end

% header data particle section
particles=[cells.particles];
if ~isempty(particles)
    particleuserdatafilednames = getUserDataFieldNames(particles);
else
    particleuserdatafilednames = [];
end
numparticleuserdata = length(particleuserdatafilednames);
% print cell userdata
for ii=1:numparticleuserdata
    switch particleuserdatafilednames{ii}
        case 'particle_pair_distance'
            ext = ' (um)';
        case 'particle_contour_distance'
            ext = ' (um)';
        otherwise
            ext='';
    end
    fprintf(file,[particleuserdatafilednames{ii},ext,',']);
end
fprintf(file,'\n');

% start data
% loop through all the cells
for icell=1:length(cells)
    %% contour data
    contours=cells(icell).contours;
    for icontour=1:length(contours)
        contour=contours(icontour);
        for iframe=1:contour.numframes
            fprintf(file,'%d,',icell);
            fprintf(file,'%s,',contour.label);
            fprintf(file, '%d,', iframe);
            for idata=1:numcontouruserdata
                try
                    udata = contour.userdata.(contouruserdatafilednames{idata});
                    if length(udata) == contour.numframes
                        udata = udata(iframe);
                    elseif length(udata) == 1
                    else
                        error('wrong user data length');
                    end
                    fprintf(file,'%f,',udata);
                catch
                    fprintf(file,',');
                end
            end
            fprintf(file,'\n');
        end
    end
    %% particle data
    particles=cells(icell).particles;
    % loop through all particles in side that cell
    for iparticle=1:length(particles)
        particle=particles(iparticle);
        % loop through all frames
        for iframe=1:particle.numframes
            fprintf(file,'%d,',icell);
            fprintf(file,'%s,',particle.label);
            fprintf(file, '%d,', iframe);
            for idata=1:numcontouruserdata
                fprintf(file,',');
            end
            for idata=1:numparticleuserdata
                try
                    udata = particle.userdata.(particleuserdatafilednames{idata});
                    if length(udata) == particle.numframes
                        udata = udata(iframe);
                    elseif length(udata) == 1
                    else
                        error('wrong user data length');
                    end
                    fprintf(file,'%f,',udata);
                catch
                    fprintf(file,',');
                end
            end
            fprintf(file,'\n');
        end
    end
end


fclose(file);
end

