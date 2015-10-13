
function  np=remove_badcentroid(np,iframe)
%remove bad centroid based on certain frames
img1=np.proj(iframe);
img1p=np.projp(iframe);
img1=img1/max(img1(:));
img1p=img1p/max(img1p(:));
rgbimg(:,:,1)=img1p;
rgbimg(:,:,3)=img1;
cnt=np.cnt_tmp;
pcnt=np.pcnt;
h=figure('Position',[100 100 700 700]);
image(rgbimg);hold on; axis image;
% DrawCircles(cnt(:,1:2),1,'g',10);
plot(cnt(:,1),cnt(:,2),'go');hold on;
plot(pcnt(:,1),pcnt(:,2),'wo');
title('left click to remove, right click to add new, press enter to continue');
exitflag=0;
while ~exitflag
    try
        [ax,ay,mousebutton]=ginput(1);
        if isempty(mousebutton)
            exitflag=1;
        else
            switch mousebutton
                case 1
                    dist=(cnt(:,1)-ax).^2+(cnt(:,2)-ay).^2;
                    min_dist=min(dist);
                    cnt=cnt(dist~=min_dist,:);
                    pcnt=pcnt(dist~=min_dist,:);
                case 3
                    cnt=[cnt;[ax,ay,(1+np.numstacks)/2]];
                    pcnt=[pcnt;[ax,ay,(1+np.numstacks)/2]];
            end
        end
        clf;
        image(rgbimg);hold on; axis image;
        %     DrawCircles(cnt(:,1:2),1,'g',10);
        plot(cnt(:,1),cnt(:,2),'go');hold on;
        plot(pcnt(:,1),pcnt(:,2),'wo');
        title('left click to remove, right click to add new, press enter to continue');
    catch
        break;
    end
end
try
close(h);
end
np.cnt_tmp=cnt;
np.pcnt=pcnt;
np.num_nuc=size(np.cnt_tmp,1);
display([num2str(np.num_nuc),' nuclei left.'])
end
