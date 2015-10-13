function [ pts,faces ] = PlotVolCubes( bw3 )
%plot volumeric cubes based a 3d bw image
%%
% bw=zeros(size(bw3)+2);
% bw(2:end-1,2:end-1,2:end-1)=bw3;
bw=bw3;

[py,px,pz]=ind2sub(size(bw),find(bw==1));
% inc is x,y,z based
inc=[-1 0 0; 1 0 0; 0 -1 0; 0 1 0; 0 0 -1; 0 0 1];% ind have to be same order as cubefaces

%cubepts is x,y,z based
cubepts=[0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1]-1/2;
% cubefaces=[find(cubepts(:,1)==-1/2)';find(cubepts(:,1)==1/2)';
%     find(cubepts(:,2)==-1/2)';find(cubepts(:,2)==1/2)';
%     find(cubepts(:,3)==-1/2)';find(cubepts(:,3)==1/2)';];
cubefaces=[1 3 4 2; 5 6 8 7;3 7 8 4;1 2 6 5;1 5 7 3;2 4 8 6];

% po.vertices=cubepts;
% po.faces=cubefaces;
% % patch(po,'CData',0:255/6:255,'CDataMapping','direct','FaceColor','flat');
% clear cdata 
% % set(gca,'CLim',[0 40])
% cdata = [1 2 3 4 5 6];
% patch(po,'FaceColor','flat',...
% 'CData',cdata,...
% 'CDataMapping','scaled')
% colormap gray;
% xlabel('x');ylabel('y');zlabel('z');
% view(3);
% camlight;
% lighting gouraud;

pts=[];
faces=[];
%loop through all the vertices
for i=1:length(px)
    xi=px(i);
    yi=py(i);
    zi=pz(i);    
    % add new vertices to the points
    [newpts,oldind]=FindNewPts(ones(8,1)*[xi yi zi]+cubepts,pts);            % not mathmatically effecient here
    tmplength=size(pts,1);
    pts=[pts;newpts];
    newind=oldind;
    newind(oldind==0)=(1:size(newpts,1))'+tmplength;    
    % find new faces
    facetmp=newind(cubefaces);
%     facetmp=facetmp(~bw(sub2ind(size(bw),yi+inc(:,2),xi+inc(:,1),zi+inc(:,3))),:);
    faces=[faces;facetmp];
end


end

