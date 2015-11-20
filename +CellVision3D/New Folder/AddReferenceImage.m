function [ obj ] = AddReferenceImage( obj, picturefilename, picture_index)
%add a picture to the analysis
global datapath;
filein=fullfile(datapath,obj.path,picturefilename);
img=zeros(obj.sizeY,obj.sizeX,obj.sizeZ);

% get extension of the file
[~,~,ext] = fileparts(filein);

% tif or normal file
if strcmp(ext,'.tiff') || strcmp(ext,'.tif')
    for istack=1:obj.numstacks
        img(:,:,istack)=imread(filein,istack);
    end
% delta vision file
elseif strcmp(ext,'.dv')
    objtmp=dvmov(filein);
    objtmp.loadmovie;
    img=objtmp.grab3(1);
else
    error('image file type not supported');
end
obj.picturefilename{picture_index}=picturefilename;
obj.pictures{picture_index}=img;
obj.numpictures=length(obj.picturefilename);

end

