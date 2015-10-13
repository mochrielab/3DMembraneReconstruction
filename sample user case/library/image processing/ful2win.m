function [ wpos ] = ful2win(wimg,cnt,pos )
%switch coordinate from full to window
% fs=size(img);
cnt=round(cnt);
ws1=size(wimg);
ws=ws1;
ws(2)=ws1(1);
ws(1)=ws1(2);
hws=(ws-1)/2;
wpos=pos-ones(size(pos,1),1)*cnt +ones(size(pos,1),1)*(hws+1);

end

