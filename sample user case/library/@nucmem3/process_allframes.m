function         nm=process_allframes(nm)
%process all the frames

for iframe=nm.continuefrom_frame:nm.endframe
    display(['processing frame ',num2str(iframe),' of ',num2str(nm.endframe),...
        ' of ',nm.filename]);

    if iframe<1
        nm.process_singleframe(1);
    else
        nm.process_singleframe(iframe);
    end
%     if 0
%         img=nm.grab(iframe,nm.focusplane);
% %         img=bpass(img,.5,5);
%         SI(img);hold on;
%         for i=1:nm.num_nuc
%             plot(nm.nuclei(iframe,i).x,nm.nuclei(iframe,i).y);
%         end
%         pause(.1);
%     end
    nm.continuefrom_frame=iframe+1;
end

end

