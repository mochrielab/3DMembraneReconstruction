function [ img3,setting ] = loadtiff( datapath,name )
%load the image stack and corresponding settings to the RAM
% do not use it to load movie, might be too large
% %%
% datapath='C:\Users\Yao\Google Drive\Movie for analysis\ecoli_chromatin';
% name='5streak2.5hrindfov1_zstack_15_41_44';

filename = fullfile(datapath,[name,'.tif']);
workspace = load(fullfile(datapath,[name,'.mat']));
setting=workspace.setting;

img=imread(filename,1);
num = length(imfinfo(filename));
img3=zeros([size(img),num]);
for inum = 1:num
    img3(:,:,inum) = imread(filename,inum);
end

end
