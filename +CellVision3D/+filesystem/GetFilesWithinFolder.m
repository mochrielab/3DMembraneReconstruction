function [ fullfiles,filepaths,filenames ] = GetFilesWithinFolder( dirpath, ext )
%get all file names within the dirpath or its sub folders
global datapath;

filenames=[];
filepaths=[];
fullfiles=[];
folderpath={dirpath};
while ~isempty(folderpath)
    % expand dir
    dirtmp=folderpath{1};
    dirlist=dir(dirtmp);
    dirlist=dirlist(3:end);
    % add new ext
    newfile=dir(fullfile(dirtmp,['*',ext]));
    if ~isempty(newfile)
        filenames=[filenames;{newfile.name}'];
        filepaths=[filepaths;repmat({dirtmp(length(datapath)+1:end)},length(newfile),1)];
        fullfiles=[fullfiles;fullfile(dirtmp(length(datapath)+1:end),{newfile.name}')];
    end
    
    if ~isempty(dirlist)
        % new folders add
        newfolders=fullfile(dirtmp,{dirlist([dirlist.isdir]).name});
        folderpath=[folderpath,newfolders];
    end
    % remove explored folder
    folderpath=folderpath(2:end);
end

end

