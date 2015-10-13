function get_zcenter_firstframe(np)

%% get the frame 
iframe=1;
img3=np.grab3(iframe);
wsz=np.wsize;
hw=(wsz-1)/2;
cnt=np.cnt_tmp;
cnt3=cnt;
for inuc=1:np.num_nuc
    wimg1=squeeze(sum(img3(round(cnt(inuc,2))+(-hw:hw),round(cnt(inuc,1))+(-hw:hw),:),1));
%     wimg2=squeeze(sum(img3(round(cnt(inuc,2))+(-hw:hw),round(cnt(inuc,1))+(-hw:hw),:),3));
   th=0.8*max(wimg1(:));
   bwimg=wimg1>th;
   props=regionprops(bwimg,'Centroid','Area');
   areatmp=[props.Area;];
   [~,areamaxind]=max(areatmp);
   tmpz=props(areamaxind).Centroid(1);
   cnt3(inuc,3)=tmpz;
%    SI(wimg1,bwimg);pause;
end
np.cnt_tmp=cnt3;

end
