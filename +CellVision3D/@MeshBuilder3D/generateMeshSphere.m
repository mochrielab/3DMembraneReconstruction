function [points,faces,edges,neighbors] = generateMeshSphere(N)
% TRISPHERE: Returns the triangulated model of a sphere using the
% icosaedron subdivision method.

%% set up icosaedron
t   = (1+sqrt(5))/2;
tau = t/sqrt(1+t^2);
one = 1/sqrt(1+t^2);
points = [
    +tau  +one  +0     % ZA
    -tau  +one  +0     % ZB
    -tau  -one  +0     % ZC
    +tau  -one  +0     % ZD
    +one  +0    +tau   % YA
    +one  +0    -tau   % YB
    -one  +0    -tau   % YC
    -one  +0    +tau   % YD
    +0    +tau  +one   % XA
    +0    -tau  +one   % XB
    +0    -tau  -one   % XC
    +0    +tau  -one]; % XD

% Structure for unit icosahedron
faces = [
    5  8  9
    5 10  8
    6 12  7
    6  7 11
    1  4  5
    1  6  4
    3  2  8
    3  7  2
    9 12  1
    9  2 12
    10  4 11
    10 11  3
    9  1  5
    12  6  1
    5  4 10
    6 11  4
    8  2  9
    7 12  2
    8 10  3
    7  3 11 ];

%% iterate
%starting param
num_faces = size(faces,1);
num_points = size(points,1);
tot_num_points = num_points;

% initialize points array
for i=1:N
    tot_num_points = 4*tot_num_points - 6;
end
points = [points; zeros(tot_num_points-12, 3)];

% refine icosahedron N times
for i = 1:N
    % initialize inner loop
    faces_old  = faces;
    faces = zeros(num_faces*4, 3);
    peMap = sparse(num_points,num_points);
    current_face = 1;
    % loop trough all old triangles
    for j = 1:num_faces
        % some helper variables
        p1 = faces_old(j,1);
        p2 = faces_old(j,2);
        p3 = faces_old(j,3);
        pts1 = points(p1,:);
        pts2 = points(p2,:);
        pts3 = points(p3,:);
        % first edge
        % -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        % sort pts index
        p1m=min([p1,p2]);
        p2m=max([p1,p2]);
        % If the point does not exist yet, calculate the new point
        p4 = peMap(p1m,p2m);
        if p4 == 0
            num_points = num_points+1;
            p4 = num_points;
            peMap(p1m,p2m) = num_points;
            points(num_points,:) = (pts1+pts2)/2;
            points(num_points,:) = points(num_points,:)...
                /sqrt(points(num_points,:)*points(num_points,:)');
        end
        
        % second edge
        % -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        % sort pts index
        p2m=min([p2,p3]);
        p3m=max([p2,p3]);
        % If the point does not exist yet, calculate the new point
        p5 = peMap(p2m,p3m);
        if p5 == 0
            num_points = num_points+1;
            p5 = num_points;
            peMap(p2m,p3m) = num_points;
            points(num_points,:) = (pts2+pts3)/2;
            points(num_points,:) = points(num_points,:)...
                /sqrt(points(num_points,:)*points(num_points,:)');
        end
        
        % third edge
        % -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
        % sort pts index
        p1m=min([p1,p3]);
        p3m=max([p1,p3]);
        % If the point does not exist yet, calculate the new point
        p6 = peMap(p1m,p3m);
        if p6 == 0
            num_points = num_points+1;
            p6 = num_points;
            peMap(p1m,p3m) = num_points;%#ok
            points(num_points,:) = (pts1+pts3)/2;
            points(num_points,:) = points(num_points,:)...
                /sqrt(points(num_points,:)*points(num_points,:)');
        end
        
        % allocate new triangles
        %   refine indexing
        %          p1
        %          /\
        %         /t1\
        %      p6/____\p4
        %       /\    /\
        %      /t4\t2/t3\
        %     /____\/____\
        %    p3    p5     p2
        faces(current_face,1) = p1; faces(current_face,2) = p4; faces(current_face,3) = p6; current_face = current_face+1;
        faces(current_face,1) = p4; faces(current_face,2) = p5; faces(current_face,3) = p6; current_face = current_face+1;
        faces(current_face,1) = p4; faces(current_face,2) = p2; faces(current_face,3) = p5; current_face = current_face+1;
        faces(current_face,1) = p6; faces(current_face,2) = p5; faces(current_face,3) = p3; current_face = current_face+1;
        
    end % end subloop
    % update number of triangles
    num_faces = current_face-1;
end % end main loop

%% edge index
edges=[];
for i=1:size(faces,1)
    edges=[edges;faces(i,1),faces(i,2);faces(i,2),faces(i,3);faces(i,1),faces(i,3)];
end
edges=sort(edges,2);
edges=unique(edges,'rows');

%% neighbor index
neighbors=nan(size(points,1),6);
neighbors_c=cell(size(points,1),1);
for i=1:size(faces,1)
    neighbors_c{faces(i,1)}=[neighbors_c{faces(i,1)},faces(i,[2,3])'];
    neighbors_c{faces(i,2)}=[neighbors_c{faces(i,2)},faces(i,[3,1])'];
    neighbors_c{faces(i,3)}=[neighbors_c{faces(i,3)},faces(i,[1,2])'];
% neighbors_c{faces(i,1)}=[neighbors_c{faces(i,1)},faces(i,2)];
% neighbors_c{faces(i,2)}=[neighbors_c{faces(i,2)},faces(i,3)];
% neighbors_c{faces(i,3)}=[neighbors_c{faces(i,3)},faces(i,1)];
end
for i=1:size(neighbors_c,1)
    neighborpool=neighbors_c{i};
    sortedneighbor=neighborpool(1);
    while ~isempty(neighborpool)
        lastneighbor=sortedneighbor(end);
        sortedneighbor=[sortedneighbor,neighborpool(2,neighborpool(1,:)==lastneighbor)];
        neighborpool=neighborpool(:,neighborpool(1,:)~=lastneighbor);
    end
    neighbors_c{i}=sortedneighbor(1:end-1);
end

for i=1:size(neighbors_c,1)
    neighbors(i,1:length(neighbors_c{i}))=neighbors_c{i};
end


%% plot triangle
if 0
    TR = triangulation(faces,points);
    trisurf(TR,'FaceColor','red');
    view(3);
    daspect([1 1 1])
    camlight
    lighting gouraud
end
end % funciton TriSphere