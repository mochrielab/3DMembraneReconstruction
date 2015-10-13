function  nm=remove_badcentroid(nm,iframe)
%remove bad centroid based on certain frames
cnt=nm.cnt_tmp;
img=nm.grab(iframe,nm.focusplane);
h=figure('Position',[100 100 700 700]);
SI(img);
hold on;
    plot(cnt(:,1),cnt(:,2),'ro');
% DrawCircles(cnt(:,1:2),1,'r',10);
title('left click to remove, right click to add new, press enter to continue');
exitflag=0;
while ~exitflag
    [ax,ay,mousebutton]=ginput(1);
    if isempty(mousebutton)
        exitflag=1;
    else
    switch mousebutton
        case 1
            dist=(cnt(:,1)-ax).^2+(cnt(:,2)-ay).^2;
            min_dist=min(dist);
            cnt=cnt(dist~=min_dist,:);
        case 3
            cnt=[cnt;[ax,ay,5.5]];
    end
    end
    clf;
    SI(img);hold on;title('left click to remove, right click to end');
%     DrawCircles(cnt(:,1:2),5,'r',10);
    plot(cnt(:,1),cnt(:,2),'ro');
end
close(h);
nm.cnt_tmp=cnt;
nm.num_nuc=size(nm.cnt_tmp,1);
display([num2str(nm.num_nuc),' nuclei left.'])
end


% %remove bad centroid based on certain frames
% cnt=nm.cnt_tmp;
% img=nm.grab(iframe,nm.focusplane);
% h=figure;
% SI(img);
% hold on;
% DrawCircles(cnt(:,1:2),1,'r',10);
% title('left click to remove, right click to end');
% exitg=1;
% while exitg==1
%     [ax,ay,exitg]=ginput(1);
%     if exitg==1
%         dist=(cnt(:,1)-ax).^2+(cnt(:,2)-ay).^2;
%         min_dist=min(dist);
%         cnt=cnt(dist~=min_dist,:);
%         clf;
%         SI(img);hold on;title('left click to remove, right click to end');
%         DrawCircles(cnt(:,1:2),5,'r',10);
%     end
% end
% close(h);
% nm.cnt_tmp=cnt;
% nm.num_nuc=size(nm.cnt_tmp,1);
% display([num2str(nm.num_nuc),' nuclei left.'])
% end

