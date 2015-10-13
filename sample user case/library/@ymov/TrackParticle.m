function [ obj ] = TrackParticle( obj, varargin )
%particle tracking on all frames
% 3/23/2015
% Yao Zhao
%%
% initial values
%psf
if ~isempty(obj.psfparam)
    psfparam=obj.psfparam;
else
    warning('missing PSF information');
end
%window size
hs=floor(obj.wsize/2);
% aberation corrected z x ratio
zxr=obj.zxr;


for iframe=obj.startframe:obj.endframe
    display(['process frame ',num2str(iframe),...
        ' out of ',num2str(obj.endframe-obj.startframe)]);
    % loop through each particle channles
    for ichannel=1:obj.numchannels
        %%
        channelname=obj.channelnames{ichannel};
        display(['channel: ',channelname]);
        tic
        
        for icell=1:obj.numdata
            %get 3d image
            img3=obj.GrabImage3D(channelname,iframe);
            %cnt guess
            if iframe==1
                pcnt=obj.data(icell).(channelname).startpeaks;
            else
                pcnt=obj.data(icell).(channelname).particle(iframe-1).value;
            end
            ccnt=round(mean(pcnt(:,1:3),1));
            nump=size(pcnt,1);
            pcntwindow=pcnt;
            pcntwindow(:,1:2)=pcnt(:,1:2)-ones(nump,1)*ccnt(1:2)+hs+1;
            % prepare image
            % get window image
            wimg3=cropimage(img3,[ccnt(2)-hs,ccnt(2)+hs,ccnt(1)-hs,...
                ccnt(1)+hs,1,size(img3,3)]);
            %             wimg3=img3(ccnt(2)+(-hs:hs),ccnt(1)+(-hs:hs),:);
            bimg3=wimg3-ImgTh(wimg3,.8);
            bimg3(bimg3<0)=0;
            bimg3=bpass3(bimg3,obj.particleparam.lnoise,...
                obj.particleparam.lobject,zxr);
            if max(bimg3(:))>0
                bimg3=bimg3./max(bimg3(:));
            end
            
            % fit to result
            ini=[pcntwindow(:,1:3),ones(nump,1)*1.5,pcntwindow(:,4)];
            lb=[max(1,pcntwindow(:,1:2)-obj.particleparam.maxdisp),...
                max(1,pcntwindow(:,3)-obj.particleparam.maxdisp/zxr),...
                ones(nump,1)*[obj.particleparam.minsigma,obj.particleparam.minpeak]];
            ub=[min(2*hs+1,pcntwindow(:,1:2)+obj.particleparam.maxdisp),...
                min(size(bimg3,3),pcntwindow(:,3)+obj.particleparam.maxdisp/zxr),...
                ones(nump,1)*[obj.particleparam.maxsigma,obj.particleparam.maxpeak]];
            %             lb=ones(nump,1)*[1,1,1,...
            %                 obj.particleparam.minsigma,obj.particleparam.minpeak];
            %             ub=ones(nump,1)*[1+2*hs,1+2*hs,size(bimg3,3),...
            %                 obj.particleparam.maxsigma,obj.particleparam.maxpeak];
            [X,Y,Z]=meshgrid(1:size(bimg3,2),1:size(bimg3,1),1:size(bimg3,3));
            gaussn=@(p)NGaussian3D2(p,X,Y,Z,bimg3,psfparam.sigdiff,zxr);
            if iframe==1
                options=optimoptions('fmincon','MaxFunEvals', 1e6,'TolX',.01,'GradObj','on','Display','off');
            else
                options=optimoptions('fmincon','MaxFunEvals', 1e6,'TolX',.01,'GradObj','on','Display','off');
                
            end
            [param,fval,exitflag,output] = fmincon(gaussn,ini,[],[],[],[],lb,ub,[],options);
            param2=param;
            param2(:,1:2)=param(:,1:2)+ones(nump,1)*ccnt(1:2)-hs-1;
            
            % save result
            if iframe==1
                tmp=struct('value',[],'resnorm',[],'exitflag',[],'output',[]);
                tmp(1:obj.numdata)=tmp;
                obj.data(icell).(channelname).particle=tmp;
            end
            obj.data(icell).(channelname).particle(iframe).value=param2;
            obj.data(icell).(channelname).particle(iframe).resnorm=fval;
            obj.data(icell).(channelname).particle(iframe).exitflag=exitflag;
            obj.data(icell).(channelname).particle(iframe).fittingdetail=output;
            
            for i=1:nargin-1
                if strcmp(varargin{i},'showplot')
                    ShowImgTrk3( bimg3,pcntwindow,param,.2,zxr,.001 )
                end
            end
        end
        toc
    end
    
end

end
