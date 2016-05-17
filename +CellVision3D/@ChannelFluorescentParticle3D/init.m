function particles=init(obj,i)
% generate cells from the a selected frame
% 11/17/2015 Yao Zhao

% get image
img=obj.grabImage3D(i);
% get cell contours
pos=obj.getPositions( img,'noshowplot' );
% save the data and generate cells
particles=repmat(CellVision3D.Particle3D.empty,1,size(pos,1));
for i=1:size(pos,1);
    particles(i)=CellVision3D.Particle3D(obj.label,pos(i,:),...
        obj.numframes,obj.zxr);
    particles(i).setPix2um(obj.pix2um);
end
% save particles to itself
obj.particles=particles;
end