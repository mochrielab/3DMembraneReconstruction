function [ nm ] = choose_endframe( nm )
%choose the end frame of analysis based on the quality of the movie
tn=9;
examined_frames=round(linspace(1,min(nm.numframes,200),tn));
m=ceil(sqrt(tn));
n=ceil(tn/m);
figuresize=800;
f=figure('NumberTitle','off','Menubar','none',...
       'Name','Click on the frame you want too choose as end frame',...
       'Position',[50 50 figuresize figuresize]);
for i=1:m*n
    [ir,ic]=ind2sub([n,m],i);
    b=uicontrol(f,'Style','Pushbutton','Position',[(ir-1)/n 1-(ic)/m 1/(n+.01) 1/(m+.01)]*figuresize);
    img=nm.grab(examined_frames(i),nm.focusplane);
    img=img/max(img(:));
    rgb=cat(3,img,img,img);
    set(b,'CData',rgb);
    set(b,'Callback',@(hObject,evendata)Callback_ChooseEndframe(examined_frames(i),f,nm,hObject,evendata));
end

waitfor(f);

end

function []=Callback_ChooseEndframe(index,hFigure,obj,hObject,eventdata)
%set the clicked window
close(hFigure);
obj.endframe=index;
display([num2str(index),' is chosen as endframe'])
end

