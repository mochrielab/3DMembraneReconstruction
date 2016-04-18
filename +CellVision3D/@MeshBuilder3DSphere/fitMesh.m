function [outputpos] = fitMesh(obj,image3,initialpos,vertices,faces,edges,neighbors,varargin)
% fit the mesh with the image
% input: image3 - image stack
%        initialpos - initial vertices positions
%        vertices - sphere vertices
%        faces - sphere faces
%        edges - sphere edges
%        neighbors - sphere neighbors
% outputpos: vertices of the fit result (image position, not scaled by zxr)
% added the option to fit a a specified scale
%  Yao Zhao 12/11/2015

% add the option to fit at the scale 3/31/2016
scale=1;
isflexible=false;
for i=1:length(varargin)/2
    switch lower(varargin{2*i-1})
        case 'scale'
            scale = varargin{2*i};
            if scale < 1 || mod(scale,1)~=0
                error('wrong scale');
            end
        case 'flexible'
            % override the radius range lower bound
            isflexible = varargin{2*i};
        otherwise
    end
end


% convert the scale  3/31/2016
% point scaled
image3 = CellVision3D.Image3D.binning(image3,scale);
% image3 = CellVision3D.Image3D.bpass(image3,obj.lnoise/scale,obj.lobject/scale,obj.zxr);


initialpos = initialpos/scale + (scale-1)/scale/2;
% calculate new radius
cnt=(mean(initialpos,1));
tmppos=initialpos-ones(size(initialpos,1),1)*cnt;
tmppos(:,3)=tmppos(:,3)*obj.zxr;
r=sqrt(sum((tmppos).^2,2));
% update param
if isflexible
    obj.updateRadiusParam([1,max(r)]);
    display('run flexible')
else
    obj.updateRadiusParam(r);
end

% z x ratio
zxr=obj.zxr;


% rounded center
ncnt=round(cnt);
dcnt=cnt-ncnt;

%% 3d to 2d img
%calculate the linear index and weights for intensity matrix


% radius range vector
rs=obj.rmin:obj.rstep:obj.rmax;

%initialize
linearindex=nan(length(initialpos),length(rs),4);
weights=zeros(length(initialpos),length(rs),4);

%points to be interpolated, coordinates in subwindow
xybordersize=3;
xs=vertices(:,1)*rs+obj.rmax+1+xybordersize+dcnt(1);
ys=vertices(:,2)*rs+obj.rmax+1+xybordersize+dcnt(2);
zs=vertices(:,3)*rs/obj.zxr+cnt(3);

% crop the image
img=CellVision3D.Image3D.crop(image3,...
    round([ncnt(2)-obj.rmax-xybordersize,ncnt(2)+obj.rmax+xybordersize,...
    ncnt(1)-obj.rmax-xybordersize,ncnt(1)+obj.rmax+xybordersize,...
    1,size(image3,3)]));

% correct for z out of range
zmin=floor(min(zs(:)));
if zmin<1
    zshift=1-zmin;
else
    zshift=0;
end
img1=img;
% add slices to bottom
for i=zmin:0
    if obj.padsame
        img1=cat(3,img(:,:,1),img1);
    else
        img1=cat(3,zeros(size(img(:,:,1)))+min(img(:)),img1);
    end
end
% add slices to top
zmax=ceil(max(zs(:)));
for i=size(image3,3):zmax
    if obj.padsame
        img1=cat(3,img(:,:,1),img1);
    else
        img1=cat(3,img1,zeros(size(img(:,:,end)))+min(img(:)));
    end
end


%floors
floor_xs=floor(xs);
floor_ys=floor(ys);
floor_zs=floor(zs);
%remains
d_xs=xs-floor_xs;
d_ys=ys-floor_ys;
d_zs=zs-floor_zs;
%linear indexes of points used in interpolation
linearindex(:,:,1)=sub2ind(size(img1),floor_ys,floor_xs,floor_zs+zshift);
linearindex(:,:,2)=sub2ind(size(img1),floor_ys,floor_xs+1,floor_zs+zshift);
linearindex(:,:,3)=sub2ind(size(img1),floor_ys+1,floor_xs,floor_zs+zshift);
linearindex(:,:,4)=sub2ind(size(img1),floor_ys+1,floor_xs+1,floor_zs+zshift);
linearindex(:,:,5)=sub2ind(size(img1),floor_ys,floor_xs,floor_zs+1+zshift);
linearindex(:,:,6)=sub2ind(size(img1),floor_ys,floor_xs+1,floor_zs+1+zshift);
linearindex(:,:,7)=sub2ind(size(img1),floor_ys+1,floor_xs,floor_zs+1+zshift);
linearindex(:,:,8)=sub2ind(size(img1),floor_ys+1,floor_xs+1,floor_zs+1+zshift);
%weights of points used in interpolation
weights(:,:,1)=(1-d_xs).*(1-d_ys).*(1-d_zs);
weights(:,:,2)=(d_xs).*(1-d_ys).*(1-d_zs);
weights(:,:,3)=(1-d_xs).*(d_ys).*(1-d_zs);
weights(:,:,4)=(d_xs).*(d_ys).*(1-d_zs);
weights(:,:,5)=(1-d_xs).*(1-d_ys).*(d_zs);
weights(:,:,6)=(d_xs).*(1-d_ys).*(d_zs);
weights(:,:,7)=(1-d_xs).*(d_ys).*(d_zs);
weights(:,:,8)=(d_xs).*(d_ys).*(d_zs);
% 3d to 2d
I=sum(img1(linearindex).*weights,3)';
% % initial radius
% tmppos=initialpos-ones(size(initialpos,1),1)*cnt;
% tmppos(:,3)=tmppos(:,3)*zxr;
% r=sqrt(sum((tmppos).^2,2));

% CellVision3D.Image2D.view(I)

%% minimizing energy
% construct cost
th2=CellVision3D.Image.getPercentageValue(I,.99);
th1=CellVision3D.Image.getPercentageValue(I,.7);
cost=sqrt((th2-th1)/2)*(10/mean(r))^2;

rs0=rs(1)/(rs(2)-rs(1))-1;
% energy function
energy=@(ind)CellVision3D.Fitting.ContourEnergy3DSphere(ind,I,cost,rs0,edges,neighbors);
% construct bound
lb_c=zeros(size(initialpos,1),1)+1.001;
ub_c=zeros(size(initialpos,1),1)+length(rs)-0.001;
ini = (r-rs(1))/(rs(2)-rs(1))+1;
% fitting
options=optimoptions('fmincon','MaxFunEvals', 1e6,'TolX',1e-3,'GradObj','on','Display','off');
[indr,fval,exitflag,output] = fmincon(energy,ini,[],[],[],[],lb_c,ub_c,[],options);
%     display(cost);
[~,grad,intensity,dr]=energy(indr);
r=rs(1)+(indr-1)*(rs(2)-rs(1));
%% update center

x=r.*vertices(:,1)+cnt(1);
y=r.*vertices(:,2)+cnt(2);
z=r.*vertices(:,3)/zxr+cnt(3);
% z=r.*vertices(:,3)+cnt(3); % not modified to rescale z, 3/23/2016
outputpos = [x,y,z];

% convert the scale  3/31/2016
outputpos = outputpos *scale - (scale-1)/2;

%% plot all together
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
if isempty(parent) && showplot
    parent=figure('Unit','Normalized','Position',[0.05 0.05 2/3 2/3]);
end

if showplot
    % calculate contour in each plane
    hw=obj.rmax+xybordersize;
    wsz=hw*2+1;
    zxr=obj.zxr;
    numstacks=size(img,3);
    %     windpos=[r.*vertices(:,1)+hw+1,r.*vertices(:,2)+hw+1,r.*vertices(:,3)/zxr+cnt(3)+zshift];
    windpos=[r.*vertices(:,1)+hw+1,r.*vertices(:,2)+hw+1,r.*vertices(:,3)/zxr+cnt(3)];
    contour=[];
    for i=1:numstacks
        [ allcontours,lowerfaces,pts] = ...
            CellVision3D.MeshBuilder3D.getCrossSection( windpos,faces,[0 0 1 i] );
        if length(allcontours)>0
            contour(i).x=allcontours{1}(:,1);
            contour(i).y=allcontours{1}(:,2);
            contour(i).area=polyarea(contour(i).x,contour(i).y);
        else
            contour(i).x=[];
            contour(i).y=[];
            contour(i).area=0;
        end
    end
    
    % fit to new center using z areas
    area=zeros(1,numstacks);
    for i=1:length(area)
        area(i)=contour(i).area;
    end
    % range of stack to fit
    meanradius = mean(r);
    stack_fit=round((-meanradius:meanradius)/zxr+cnt(3));
    stack_fit=max(1,stack_fit(1)):min(numstacks,stack_fit(end));
    % areas to fit
    area_fit=area(stack_fit);
    % scale stack z
    stack_z=stack_fit*zxr;
    % init values
    ini_g=[meanradius,cnt(3)*zxr];
    lb_g=[1,min(stack_z)];
    ub_g=[2*meanradius,max(stack_z)];
    options_sphere=optimset('TolX',5e-2,'TolFun',1e-2,'Display','off');
    % fitting
    gaussfit=@(P) CellVision3D.Fitting.AreaSphere(P,stack_z) - area_fit;
    gfit=lsqnonlin(gaussfit,ini_g,lb_g,ub_g,options_sphere);
    %     f=figure(103);
    %     set(f,'Unit','pixels','Position',[0 50 1000 750]);
    %     clf
    
    % delete previous
    delete(get(parent,'Children'));
    % plot 3D shape
    axes('Parent',parent,'Unit','pixel','Position',[0 400 350 350]);
    pts=[r.*vertices(:,1),r.*vertices(:,2),r.*vertices(:,3)];
    p.vertices=pts;
    p.faces=faces;
    patch(p,'FaceColor','red','EdgeColor','black');
    plotwinsiz3D = max(r)+1;
    axis([-1 1 -1 1 -1 1]*plotwinsiz3D);
    grid off
    view(3);
    daspect([1 1 1])
    camlight
    lighting gouraud
    
    axes('Parent',parent,'Unit','pixel','Position',[370 420 310 310]);
    neighbors(1:12,6)=(1:12)';
    r_energy=sum((indr(neighbors)-indr*ones(1,6)).^2,2)*cost(1);
    plot(1:length(intensity),intensity,1:length(intensity),r_energy)
    axis([0 length(intensity) 0 65535])
    legend('intensity','bending energy')
    
    axes('Parent',parent,'Unit','pixel','Position',[720 420 270 310]);
    area=zeros(1,numstacks);
    for i=1:length(area)
        area(i)=contour(i).area;
    end
    stack_g=(1:.1:numstacks)*zxr;
    area_g=CellVision3D.Fitting.AreaSphere(gfit,stack_g);
    plot(1:length(area),area,'ob',stack_g/zxr,area_g,'r-');
    axis([0 numstacks 0 max(area)*1.2]);
    xlabel('stack id');
    ylabel('area (pixel^2)');
    
    % plot ten stacks
    for i=1:10
        % set window layouts
        pr=floor((i-1)/5);
        pc=i-5*pr-1;
        pr=1-pr;
        imgsize=200;
        axes('Parent',parent,'Unit','pixel','Position',[pc*imgsize pr*imgsize imgsize imgsize]);
        cla;
        % set stack interval
        %         stacki=round(cnt(3)-0.5)+(i-5)*floor((numstacks/10)^.7);
        %         istack = max(1,round(meanradius/zxr/4.5))*(i-6)+round(cnt(3)-.5);
        istack = max(1,round(numstacks/11))*(i-6)+round(cnt(3)-.5);
        % plot each stack
        if istack>=1 && istack<=numstacks
            imagesc(img(:,:,istack));colormap gray;axis image;
            xi=contour(istack).x;
            yi=contour(istack).y;
            hold on;
            plot(xi,yi,'-','Linewidth',2);
            axis off;
            box on;
            text(5,3,['Zstack:',num2str(istack)],'Color','r','FontWeight','bold','FontSize',15);
            text(5,wsz-3,['Area:',num2str(contour(istack).area)],'Color','y','FontWeight','bold','FontSize',15);
            if i==1
                %                 text(5,10,['frame: ',num2str(iframe),' nuclei: ',num2str(inuc)],...
                %                     'Color','r','FontWeight','bold','FontSize',15);
                text(5,20,[{'nuc center'},{['x:',num2str(cnt(1))]},...
                    {['y:',num2str(cnt(2))]},{['z:',num2str(cnt(3))]}],...
                    'Color','g','FontWeight','bold','FontSize',15);
            end
        end
    end
    drawnow;
end


end

