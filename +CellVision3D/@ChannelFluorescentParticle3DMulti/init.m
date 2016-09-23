function particles=init(obj,i)
% generate cells from the a selected frame
% 11/17/2015 Yao Zhao

% get image
img=obj.grabImage3D(i);
% get cell contours
pos=obj.getPositions( img,'noshowplot' );

if  obj.multiplier > 1 %%size(pos,1) == 1 &&
    pos2 = zeros(size(pos,1)*obj.multiplier, size(pos,2));
    for i = 1:size(pos,1)
        pos2(obj.multiplier*(i-1)+1:i*obj.multiplier,:) = ones(obj.multiplier,1)*pos(i,:);
    end
end
pos2(:,1:3) = pos2(:,1:3)+obj.delta*randn(size(pos2,1),3);
pos=pos2;
% if size(pos,1) > 1 && obj.multiplier > 1
%     error('we do not know what to do if there are multiple particles')
% end

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