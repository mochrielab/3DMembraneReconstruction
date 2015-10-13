function [ np ] = get_particle_firstframe( np )
%get particle centroid of the first frame
%%
img=np.projp(1);
img3=np.grab3p(1);
cnt=round(np.cnt_tmp(:,1:2));
hs=(np.wsize-1)/2;
pcnt=zeros(size(np.cnt_tmp));
for inuc=1:np.num_nuc
    wimg=img(cnt(inuc,2)+ (-hs:hs),cnt(inuc,1)+(-hs:hs));
    wimg3=img3(cnt(inuc,2)+ (-hs:hs),cnt(inuc,1)+(-hs:hs),:);
    bimg=bpass(wimg,.5,5);
    pks=pkfnd(bimg,.5,3);
    cnttmp=cntrd(bimg,pks,5);
    if ~isempty(cnttmp)
        [~,maxind]=max(cnttmp(:,3));
        px=cnttmp(maxind,1);
        py=cnttmp(maxind,2);
        zint=squeeze(wimg3(round(py),round(px),:));
        [~,pz]=max(zint);
        pcnt(inuc,:)=[px-hs-1,py-hs-1,pz]+[cnt(inuc,1:2),0];
    else
        pcnt(inuc,:)=[nan,nan,nan];
    end
end

np.pcnt=pcnt;
    SI(img);hold on;plot(pcnt(:,1),pcnt(:,2),'o');
end

