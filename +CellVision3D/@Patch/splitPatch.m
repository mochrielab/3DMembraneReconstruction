function [ patches ] = splitPatch( patch )
% split one patch into array of patches 
% 3/31/2016 Yao Zhao

if isempty(patch.numpatches)
    patch.labelPatch;
end

if patch.numpatches <=1
    patches=patch;
else
    patches=[];
    for ipatch=1:patch.numpatches
        pchoose=patch.ptspid==ipatch;
        p.vertices = patch.vertices(pchoose,:);
        numv = size(p.vertices,1);
        vconversion =zeros(size(pchoose));
        vconversion(pchoose)=1:numv;
        p.faces = vconversion(patch.faces(patch.facespid==ipatch,:));
        patches=[patches,CellVision3D.Patch(p)];
        patches(ipatch).labelPatch;
    end
end

end

