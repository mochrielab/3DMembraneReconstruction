function [ dataout ] = getdata( moviepath,folders,fun_getdata,fun_isfiltered)
%gather data from different folder
dataout=cell(1,length(folders));
for ifolder=1:length(folders)
    files=dir([moviepath,'\',folders(ifolder).name,'\*.mat']);
    data_tmp=[];
    for ifile=1:length(files)
        filename=fullfile([moviepath,'\',folders(ifolder).name],files(ifile).name);
        load(filename);
        for  inuc=1:np.num_nuc;
            if fun_isfiltered(np,inuc)
                data_tmp=[data_tmp,fun_getdata(np,inuc)];
            end
        end
    end
    dataout{ifolder}=data_tmp;
end
end

