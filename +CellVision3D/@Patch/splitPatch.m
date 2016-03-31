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
        p.vertices = patch.vertices(patch.ptsid==ipatch,:);
        p.faces = patch.faces(patch.facespid==ipatch,:);
        patches=[patches,CellVision3D.Patch(p)];
    end
end

end

