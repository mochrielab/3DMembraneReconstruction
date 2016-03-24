function [ cnt2,index] = RemoveNearBorder( cnt,img,half_win )
%remove centroid near the border of the image within half window size
%works for both 2d and 3d, 
cnt2=[];
index=false(size(cnt,1),1);
% [sizey,sizex]=size(img);
sizey=size(img,1);
sizex=size(img,2);
maxx=sizex-half_win;
maxy=sizey-half_win;
for i=1:size(cnt,1)
    if cnt(i,1)>half_win && cnt(i,1)<maxx ...
            && cnt(i,2)>half_win && cnt(i,2)<maxy
        cnt2=[cnt2;cnt(i,:)];
        index(i)=true;
    end
end
end

