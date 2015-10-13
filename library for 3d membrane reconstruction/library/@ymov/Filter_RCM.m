function [ goodcell ] = Filter_RCM( obj )
% cell filter
% rod like, center, mitotic
% choose cells that have particles only in the center range of rod likecell


goodcell=true(obj.numdata,1);
for icell=1:obj.numdata
    % get center , orientation, and peaks
    cnt=obj.data(icell).contour.center;
    theta=obj.data(icell).contour.theta;
    for ichannel=1:obj.numchannels
        if strcmp(obj.channeltypes{ichannel},'fp')
            channelname=obj.channelnames{ichannel};
            peaks=obj.data(icell).(channelname).startpeaks;
            nump=size(peaks,1);
            numpeakones=ones(nump,1);
            % decide if number of particles is good
            if ~( nump>=obj.filterparam.(channelname).number_min ...
                    && nump <= obj.filterparam.(channelname).number_max)
                goodcell(icell)=0;
                %             break;
            end
            % decide if short axis and long axis is in range
            if ~isempty(peaks);
                longaxis=abs(sum((peaks(:,1:2)-numpeakones*cnt).*(numpeakones*[cos(theta),-sin(theta)]),2));
                shortaxis=abs(sum((peaks(:,1:2)-numpeakones*cnt).*(numpeakones*[-sin(theta),cos(theta)]),2));
                % all four apply for all dots
                if min(longaxis>=obj.filterparam.(channelname).longaxis_distance_from_center_min ...
                        & longaxis<=obj.filterparam.(channelname).longaxis_distance_from_center_max ...
                        &  shortaxis>=obj.filterparam.(channelname).shortaxis_distance_from_center_min ...
                        & shortaxis<=obj.filterparam.(channelname).shortaxis_distance_from_center_max )==0
                    goodcell(icell)=0;
                end
            end
            
        end
    end
    %save
    obj.data(icell).good=goodcell(icell);
end




end

