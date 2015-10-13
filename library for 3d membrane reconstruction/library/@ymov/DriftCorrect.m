function [ obj ] = DriftCorrect( obj, mod, varargin )
%correct drift for the movie
% 3/23/2015
% Yao Zhao

% for i=1:nargin-1
%
%     if varargin{}
%
% end

if strcmp(mod,'particle motions')
    %%
    drift=zeros(obj.numframes,3);
    for iframe = obj.startframe:obj.endframe
        tmpcnt=[];
        for icell=1:obj.numdata
            for ichannel=1:obj.numchannels
                tmpcnt=[tmpcnt; obj.data(icell). ...
                    (obj.channelnames{ichannel}).particle(iframe).value];
            end
        end
        drift(iframe,:)=mean(tmpcnt(:,1:3),1);
    end
    drift=drift-ones(size(drift,1),1)*drift(1,:);
    %     obj.driftparam.fNorm=.1
    [b,a] = butter(obj.driftparam.order, obj.driftparam.fNorm, 'low');
    lowpassdrift=zeros(size(drift));
    lowpassdrift(:,3) = filtfilt(b, a, drift(:,3));
    lowpassdrift(:,2) = filtfilt(b, a, drift(:,2));
    lowpassdrift(:,1) = filtfilt(b, a, drift(:,1));
    
    %
    for i=1:nargin-2
        if strcmp(varargin{i},'showplot')
            plot3(drift(:,1),drift(:,2),drift(:,3),'b'); hold on;
            plot3(lowpassdrift(:,1),lowpassdrift(:,2),lowpassdrift(:,3),'r');
            legend('mean center','lowpass filtered');
            axis equal;
        end
    end
    
    obj.drift=lowpassdrift;
    
    
else
    warning('drift correction mod not found');
end

end

