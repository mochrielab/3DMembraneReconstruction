function [img_filt] = excludeRegions(obj,regionNum)
    for k = 1:regionNum % Loop for multiple regions in image to be 
                        % excluded.
        midplane = round(length(obj)/2); % Find midplane of z-stack.

        mask = roipoly(obj(:,:,midplane)); % Use polygon tool to 
                                                  % draw polygon around
                                                  % region to be excluded.
                                                  % When finished closing
                                                  % polygon, double click
                                                  % in center of polygon
                                                  % to save polygon mask.
        
        if k == 1
            img_filt = obj; % Create image copy to be filtered.
        end

        figure
        imshowpair(img_filt(:,:,midplane),mask) % Show mask on top of 
                                                % original image to show
                                                % the region to be
                                                % converted to zeros.

        [mask_y, mask_x] = find(mask); % Save mask [row, column] 
                                       % coordinates as separate vectors.

        for j = 1:length(img_filt) % For each z slice...
            for i = 1:length(mask_x) % For each mask coordinate...
                img_filt(mask_y(i),mask_x(i),j) = 0; % Convert the 
                                                     % corresponding image
                                                     % coordinate value to
                                                     % zero.
            end
        end

        figure
        imshow(img_filt(:,:,midplane)) % Show filtered image result.
    end
end
