function viewMSD(msds,varargin)
% view the msd data
% input:
%        msd handle
%        optional input: x, y, z, all

plotx=false;
ploty=false;
plotz=false;
plotsum=false;
if nargin>=2
    for i=1:nargin-1
        switch lower(varargin{i})
            case 'x'
                plotx=true;
            case 'y'
                ploty=true;
            case 'z'
                plotz=true;
            case 'all'
                plotx=true;
                ploty=true;
                plotz=true;
            case 'sum'
                plotsum=true;
        end
    end
end
[meanMSD,seMSD]=CellVision3D.DiffusionAnalysis.getMSDStats(msds);

if plotx==true
    errorbar(meanMSD.t,meanMSD.x,seMSD.x,'color','r');hold on;
end
if ploty==true
    errorbar(meanMSD.t,meanMSD.y,seMSD.y,'color','g');hold on;
end
if plotz==true
    errorbar(meanMSD.t,meanMSD.z,seMSD.z,'color','b');hold on;
end
if plotsum==true
    errorbar(meanMSD.t,meanMSD.sum,seMSD.sum,'color','k');hold on;
end




end

