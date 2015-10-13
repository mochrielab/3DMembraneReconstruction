function [ obj ] = GetContourProperties( obj )
% get contour properties for the data
% 3/23/2015
% Yao Zhao


for icell=1:obj.numdata
    bb=obj.data(icell).contour.startcontour;
    bw=zeros(obj.sizeY,obj.sizeX);
    bw(sub2ind(size(bw),bb(:,2),bb(:,1)))=1;
    bw=imfill(bw,'holes');
    cc=regionprops(bw,'MajorAxisLength','MinorAxisLength',...
        'Centroid','Orientation');
    obj.data(icell).contour.length=cc.MajorAxisLength;
    obj.data(icell).contour.width=cc.MinorAxisLength;
    obj.data(icell).contour.center=cc.Centroid;
    obj.data(icell).contour.theta=cc.Orientation*pi/180;
    obj.data(icell).contour.focalplane=obj.cellcontour_ff.focalplane;
        
    theta=cc.Orientation*pi/180;
    pts= [-1 -1; -1 1; 1 1; 1 -1; -1 -1]...
        .*([1 1 1 1 1]'*[cc.MajorAxisLength,cc.MinorAxisLength])/2;
    box=[pts(:,1)*cos(theta)+pts(:,2)*sin(theta),...
        pts(:,2)*cos(theta)-pts(:,1)*sin(theta)]+...
        [1 1 1 1 1]'*cc.Centroid;
    obj.data(icell).contour.box=box;
    
end

end


