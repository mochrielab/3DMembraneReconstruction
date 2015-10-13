function [ obj ] = PlotMeshStack( obj,varargin)
%show the mesh in a stack
%%

pausesec=1;
if nargin>1
    pausesec=varargin{1};
end

%initialize
pts=obj.vertices;
faces=obj.faces;
edges=obj.edges;
neighbors=obj.neighbors;
numpts=size(pts,1);
numfaces=size(faces,1);
numedges=size(edges,1);
imagesz=size(obj.image);
zxr=obj.zxr;

for istack=2:size(obj.image,3)
    
    clf
    % plot the cross section
    v=obj.image(:,:,1:istack);
    patch(isocaps(v*256,1),'FaceColor','interp','EdgeColor','none');hold on;
    colormap gray;
    
    % plot fit contour
    [allcontours,lowerfaces,lowerpts]=obj.GetCrossSection([0 0 1 istack*zxr]);
    for i=1:length(allcontours)
        c=allcontours{i};
        plot3(c(:,1),c(:,2),c(:,3)/zxr,'b');hold on;
    end
    
    %plot patch
    p.vertices=[lowerpts(:,1:2),lowerpts(:,3)/zxr];
    p.faces=lowerfaces;
    patch(p,'FaceColor','r','EdgeColor','none'); hold on;
    
    % plot properties
        lighting gouraud;
        camlight('headlight');
    view(3);
%     maxxyz=max(pts);
%     minxyz=min(pts);
%     mg=3;
%     axis([minxyz(1)-mg maxxyz(1)+mg minxyz(2)-mg maxxyz(2)+mg ...
%         minxyz(3)/zxr-mg maxxyz(3)/zxr+mg])
        axis([1 imagesz(1) 1 imagesz(2) 1 imagesz(3)]);
%         axis equal
        daspect([1 1 1])
%     daspect([1 1 1/1.8])
    pause(pausesec)
end
end



% img1=obj.image;
% p2=isosurface(img1,.5*img1);
% p2.vertices(:,3)=p2.vertices(:,3)*obj.zxr;
%
% p1.vertices=obj.vertices;
% p1.faces=obj.faces;
%
% SP(p1,[],'k',.5);
% SP(p2,'b',[],.5);
%
% legend('fitted','original');

% for istack=2:size(obj.image,3)
%
%     % plot patch of the lower half
%     usefaces=zeros(numfaces,1);
%     for iface=1:numfaces
%         pz=pts(faces(iface,:),3);
%         if min(pz)<istack*zxr
%             usefaces(iface)=1;
%         end
%     end
%

