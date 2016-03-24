function  [param2,resnorm]=fitPositions(obj,img3,pcnt,varargin)
% fit to positions
% img3 is the full size image stack
% pcnt is the positions estimations of the particles to be fitted in to the
% same window
% fitting type is NDGaussian3D2, zero background fixed xz ratio 3d gaussian
% add 'showplot' to plot after fitting
%
% 11/18/2015 Yao Zhao
import CellVision3D.*
%center of the window guess
ccnt=round(mean(pcnt(:,1:3),1));
%number of particles
nump=size(pcnt,1);
% half window size
hs=(obj.fitwindow-1)/2;
% particle positions in a window
pcntwindow=pcnt;
pcntwindow(:,1:2)=pcnt(:,1:2)-ones(nump,1)*ccnt(1:2)+hs+1;
% get window image
wimg3=CellVision3D.Image3D.crop(img3,[ccnt(2)-hs,ccnt(2)+hs,ccnt(1)-hs,...
    ccnt(1)+hs,1,size(img3,3)]);
% clean up image for fitting
bimg3=CellVision3D.Image3D.bpass(wimg3,obj.lnoise,obj.lobject,obj.zxr);
% fit to result
zxr=obj.zxr;
ini=[pcntwindow(:,1:3),ones(nump,1)*1.5,ones(nump,1)*2.5,pcntwindow(:,4)];
lb=[max(1,pcntwindow(:,1:2)-obj.mindist),...
    max(1,pcntwindow(:,3)-obj.mindist/zxr),...
    ones(nump,1)*[obj.minsigma,obj.minsigma,obj.minpeak*max(bimg3(:))]];
ub=[min(2*hs+1,pcntwindow(:,1:2)+obj.mindist),...
    min(size(bimg3,3),pcntwindow(:,3)+obj.mindist/zxr),...
    ones(nump,1)*[obj.maxsigma,obj.maxsigma,obj.maxpeak*max(bimg3(:))]];
% construct fitting function
[X,Y,Z]=meshgrid(1:size(bimg3,2),1:size(bimg3,1),1:size(bimg3,3));
gaussn=@(p)Fitting.NGaussian3D0B2S(p,X,Y,Z,bimg3,zxr);
options=optimoptions('fmincon','MaxFunEvals', 1e6,'TolX',1e-6,'GradObj','on','Display','off');
% fitting
[param,fval,exitflag,output] = fmincon(gaussn,ini,[],[],[],[],lb,ub,[],options);
% scale back to full image
param2=param;
param2(:,1:2)=param(:,1:2)+ones(nump,1)*ccnt(1:2)-hs-1;
% resnorm
resnorm=sqrt(fval/numel(wimg3))/sqrt(sum(bimg3(:).^2));


% 
showplot=0;
parent=[];
for i=1:length(varargin)/2
    switch lower(varargin{2*i-1})
        case 'showplot'
            showplot = varargin{2*i};
        case 'parent'
            parent = varargin{2*i};
    end
end
if showplot
    obj.plotParticleZstack( bimg3,pcntwindow,param,.2,zxr,.005,parent );
end

end


% 
% % 11/18/2015 Yao Zhao
% import CellVision3D.*
% %center of the window guess
% ccnt=round(mean(pcnt(:,1:3),1));
% %number of particles
% nump=size(pcnt,1);
% % half window size
% hs=(obj.fitwindow-1)/2;
% % particle positions in a window
% pcntwindow=pcnt;
% pcntwindow(:,1:2)=pcnt(:,1:2)-ones(nump,1)*ccnt(1:2)+hs+1;
% % get window image
% wimg3=CellVision3D.Image3D.crop(img3,[ccnt(2)-hs,ccnt(2)+hs,ccnt(1)-hs,...
%     ccnt(1)+hs,1,size(img3,3)]);
% % clean up image for fitting
% bimg3=CellVision3D.Image3D.bpass(wimg3,obj.lnoise,obj.lobject,obj.zxr);
% % fit to result
% zxr=obj.zxr;
% ini=[pcntwindow(:,1:3),ones(nump,1)*1.5,pcntwindow(:,4)];
% lb=[max(1,pcntwindow(:,1:2)-obj.mindist),...
%     max(1,pcntwindow(:,3)-obj.mindist/zxr),...
%     ones(nump,1)*[obj.minsigma,obj.minpeak*max(bimg3(:))]];
% ub=[min(2*hs+1,pcntwindow(:,1:2)+obj.mindist),...
%     min(size(bimg3,3),pcntwindow(:,3)+obj.mindist/zxr),...
%     ones(nump,1)*[obj.maxsigma,obj.maxpeak*max(bimg3(:))]];
% % construct fitting function
% [X,Y,Z]=meshgrid(1:size(bimg3,2),1:size(bimg3,1),1:size(bimg3,3));
% gaussn=@(p)Fitting.NGaussian3D0B(p,X,Y,Z,bimg3,1.2,zxr);
% options=optimoptions('fmincon','MaxFunEvals', 1e6,'TolX',.01,'GradObj','on','Display','off');
% % fitting
% [param,fval,exitflag,output] = fmincon(gaussn,ini,[],[],[],[],lb,ub,[],options);
% % scale back to full image
% param2=param;
% param2(:,1:2)=param(:,1:2)+ones(nump,1)*ccnt(1:2)-hs-1;
% % resnorm
% resnorm=sqrt(fval/numel(wimg3))/sqrt(sum(bimg3(:).^2));
% 
% for i=1:nargin-3
%     if strcmp(varargin{i},'showplot')
%         obj.plotParticleZstack( bimg3,pcntwindow,param,.2,zxr,.05 )
%     end
% end
% 
% % pause
% end