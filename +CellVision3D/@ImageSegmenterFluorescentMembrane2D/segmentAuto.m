function out=segmentAuto(obj,im)
% segment a 2d fluorescent image using canny edge detection
% will automatically search for the best parameters
% 3/24/2016 Yao Zhao

%%
import CellVision3D.*
lnoise=obj.lnoise;
lobject=obj.lobject;
% calcualte linear background
im=Image2D.removeLinearBackground(im);
% bandpass filter to remove background
bimg=Image2D.bpass(im,lnoise,lobject);

% create an array of parameters
numinit = obj.ncycles;
th_array = zeros(numinit,2);
fmin_array = zeros(numinit,1);

% try 10 set of different parameters
for i=1:numinit
    % do a optimization with canny edge filter parameter,
    % init=[.3,.9]';
    lb=[.01, .05]';
    ub=[.9, .95]';
    % randomize a ini param
    init=[rand^2,1]'*(rand*(ub(2)-lb(2))+lb(2));
    if init(1)<lb(1)
        init(1)=lb(1);
    end
    if init(1)>ub(1)
        init(1)=ub(1);
    end
    % gradient decent
    options=optimoptions('fmincon','DiffMinChange',0.1,'Display','off');
    p=fmincon(@(th)foptim(th,bimg,lobject),init,[1 -1],[0.01],[],[],lb,ub,[],options);
    % save parameter and fmin
    th_array(i,:)=p';
    fmin_array(i)=foptim(p,bimg,lobject);
end

% choose the best result
[~,minind]=min(fmin_array);
p=th_array(minind,:);
if p(1)>=p(2)
    p(1)=0.9*p(2);
end

% reconstruct the optimized image
bw2=edge(bimg,'canny',[p(1),p(2)]);
% clean up the image
bw2=bwmorph(bw2,'close');
bw2=imfill(bw2,'holes');
% region properties filters
ccs=regionprops(bw2,'area','Centroid','PixelIdxList','Perimeter','Eccentricity');
cnt=[ccs.Centroid];
cnt=[cnt(1:2:end)',cnt(2:2:end)'];
area=[ccs.Area];
areamax=pi*lobject^2/4*4;
areamin=pi*lobject^2/4/4;
eccentricity=[ccs.Eccentricity];
prratio=[ccs.Perimeter]/2/pi./sqrt(area/pi);
[~,index]=Image.removeNearBorder( cnt,im,lobject );
ccs=ccs(area<areamax & area>areamin & index' & eccentricity<.6 ...
    & prratio < 3);
out=ccs;

%             bw3=zeros(size(bw2));
%             for i=1:length(ccs)
%                 bw3(ccs(i).PixelIdxList)=1;
%             end
%
% function to be optimized
    function fmin=foptim(th,bimg,lobject)
        if(th(1)>th(2))
%             warning('intermediate result out of bound');
            th(1)=0.90*th(2);
            %             fmin=inf;
            %             return;
        end
        % edges
        e=edge(bimg,'canny',[th(1),th(2)]);
        % fill close space
        e=bwmorph(e,'close');
        imf=imfill(e,'holes');
        % calculate area sizes that falls into [1/4 4] range of the desired
        % object
        cc=regionprops(imf,'area');
        a=[cc.Area];
        amax=pi*lobject^2/4*4;
        amin=pi*lobject^2/4/4;
        % calculate total detected area
        selected=a>amin&a<amax;
        %         a=sum(a(selected));
        %         l=sum(e(selected));
        %         fmin=-a + l;
        
        fmin = -sum(a(selected))+sum(e(selected));
%         fmin = -pi*lobject^2/4*sum(selected)+sum(e(selected))-sum(2*sqrt(pi*a(selected)));
    end

% % nonlinear constraints
%     function [c, ceq] = nlcon ()
%     end
end