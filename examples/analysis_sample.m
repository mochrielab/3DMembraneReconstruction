%% setting up and load movie
clear all;close all;clc;
% select movie file
dirpaths={'C:\Users\Yao\Google Drive\Movie for analysis\particle_correlation_movies\cut3',...
    'C:\Users\Yao\Google Drive\Movie for analysis\particle_correlation_movies\ade8',...
    ...    'C:\Users\Yao\Google Drive\Movie for analysis\particle_correlation_movies\cen2',...
    ...    'C:\Users\Yao\Google Drive\Movie for analysis\particle_correlation_movies\rap1',...
    };
spb={};
loci={};
ifilet=0;
for idir = 1:length(dirpaths)
    dirpath=dirpaths{idir};
    % filename='cut3_lacOlacIGFP_sad1mcherry_30s_1hr_02_R3D.dv';
    files = dir(fullfile(dirpath,'*.mat'));
    filenames={files.name};

    % par for ifile=1:length(filenames);
    for ifile=1:length(filenames)
        ifilet = ifilet+1;
        allposSPB = zeros(0,121,3);
        allposLOCI = zeros(0,121,3);
        %%
        index=0;
        clf
        filenames{ifile}
        load(fullfile(dirpath,filenames{ifile}));
        % calculate drift
        dft = zeros(movie.numframes,3);
        for icell=1:length(cells)
            particles = cells(icell).particles;
            labels={particles.label};
            pSPB = particles(strcmp(labels,'SPB')).positions;
            pLOCI = particles(strcmp(labels,'loci')).positions;
            dft = dft + (pSPB - ones(size(pSPB,1),1)*pSPB(1,:)) + (pLOCI - ones(size(pLOCI,1),1)*pLOCI(1,:)) ;
            
        end
        dft = dft/length(cells)/2;
        
        % deduct drift
        for icell=1:length(cells)
            particles = cells(icell).particles;
            labels={particles.label};
            pSPB = particles(strcmp(labels,'SPB')).positions-dft;
            pLOCI = particles(strcmp(labels,'loci')).positions-dft;
            plot3(pSPB(:,1),pSPB(:,2),pSPB(:,3),'g');hold on;
            plot3(pLOCI(:,1),pLOCI(:,2),pLOCI(:,3),'r');hold on;
            daspect([1 1 1])
            hold on;
        end
        
        if ~sum(strcmp(filenames{ifile},{'cut3_lacO_lacIGFP_sad1mcherry_MBC_30s_1hr_02_R3D.mat',...
                'ade8_lacOlacIGFP_sad1mcherry_30s_1hr_01_R3D.mat',...
                'cut3_lacOlacIGFP_sad1mcherry_30s_1hr_01_R3D.mat',...
                }))
            % deduct drift
            for icell=1:length(cells)
                particles = cells(icell).particles;
                labels={particles.label};
                pSPB = particles(strcmp(labels,'SPB')).positions-dft;
                pLOCI = particles(strcmp(labels,'loci')).positions-dft;
                index =  index + 1;
                allposSPB(index,:,:) = pSPB;
                allposLOCI(index,:,:) = pLOCI;
                
                pSPBm = mean(pSPB,1);
                pLOCIm = mean(pLOCI,1);
                pSPB = pSPB - ones(121,1)*pSPBm;
                pLOCI = pLOCI - ones(121,1)*pLOCIm;
                cSPB = zeros(3,3);
                cLOCI = zeros(3,3);
                for ir=1:3
                    for ic=1:3
                        cSPB(ir,ic)=cov(pSPB(:,ir),pSPB(:,ic));
                        cLOCI(ir,ic)=cov(pLOCI(:,ir),pLOCI(:,ic));
                    end
                end
                eigSPB = eig(cSPB);
                eigLOCI = eig(cLOCI);
            end
            display('keep')
        else
            display('not keep')
        end
        spb{ifilet}=allposSPB;
        loci{ifilet}=allposLOCI;
        savefig(num2str(ifilet));
        pause
    end

end
%%
spb_cut3_mbc=spb{1};
loci_cut3_mbc=loci{1};
spb_cut3=cat(1,spb{4},spb{5});
loci_cut3=cat(1,loci{4},loci{5});
spb_ade8 = spb{7};
loci_ade8 = loci{7};

names = {'spb_cut3_mbc','loci_cut3_mbc','spb_cut3','loci_cut3','spb_ade8','loci_ade8'};
for i=1:6
    eval(['numbers(i)=size(',names{i},',1);']);
end
bar(1:3,numbers(1:2:end))
set(gca,'XTickLabel',cellfun(@(x)strrep(x,'_',' '),names(1:2:end),'UniformOutput',0))
print(gcf,'number','-dpng')
%%
bins=0:0.2:2;
c1=zeros(6,length(bins));
for iname = 1: length(names)
    name=names{iname};
    eval(['std_',num2str(iname),'=sqrt(sum(squeeze(std(',name,',[],2)).^2,2))*0.16;'])
    eval(['tmp=hist(std_',num2str(iname),',bins);']);
    eval(['c1(',num2str(iname),',:)=tmp/sum(tmp)'])
end

plot(bins',c1','LineWidth',2);
xlabel('standard devation of motion (\mum)')
ylabel('percentage')
legend(cellfun(@(x)strrep(x,'_',' '),names,'UniformOutput',0));
print(gcf,'std','-dpng')

%%
c2=zeros(3,length(bins));
bins2=0:0.2:2;
for iname = 1:2: length(names)
    eval(['p1=',names{iname},';']);
    eval(['p2=',names{iname+1},';']);
    tmp = sqrt(sum((squeeze(mean(p1,2)-mean(p2,2))).^2,2))*0.16;
    ctmp = hist(tmp,bins2);
    c2((iname+1)/2,:) = ctmp/sum(ctmp);
%     eval(['std_',num2str(iname),'=sqrt(sum(squeeze(std0(',name,',[],2)).^2,2))*0.16;'])
end
plot(bins2',c2','LineWidth',2);
xlabel('SPB loci distance (\mum)')
ylabel('percentage')
legend(cellfun(@(x)strrep(x,'_',' '),names(1:2:end),'UniformOutput',0));
print(gcf,'distance','-dpng')

%%






