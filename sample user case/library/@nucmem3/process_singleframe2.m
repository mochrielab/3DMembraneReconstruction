function [ nm ] = process_singleframe2( nm ,iframe)
%process a single frame of the movie
% second round fitting obsolete
%% initialize
num_nuc=nm.num_nuc;
wsz=nm.wsize;
hw=(wsz-1)/2;
rs=nm.rs;
points=nm.points;
faces=nm.faces;
edges=nm.edges;
neighbors=nm.neighbors;
zxr=nm.vox/nm.pix*nm.aberation;

%get img
img=nm.grab3(iframe);

for inuc=1:num_nuc
    tic
    %% grab wimg
    %set curruent origin of fitting
    nuc_origin=nm.nuclei{iframe,inuc}.origin_new;

    %% 3d to 2d img
    %calculate the linear index and weights for intensity matrix
    %initialize
    linearindex=nan(length(points),length(rs),4);
    weights=zeros(length(points),length(rs),4);
    %points to be interpolated
    xs=points(:,1)*rs+nuc_origin(1);
    ys=points(:,2)*rs+nuc_origin(2);
    zs=points(:,3)*rs/zxr+nuc_origin(3);
    % correct for z overshot
    zmin=floor(min(zs(:)));
    if zmin<1
        zshift=1-zmin;
    else
        zshift=0;
    end
    img1=img;
    % add slices to bottom
    for i=zmin:0
        img1=cat(3,img(:,:,1),img1);
    end
    % add slices to top
    zmax=ceil(max(zs(:)));
    for i=11:zmax
        img1=cat(3,img1,img(:,:,end));
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
    
    %% minimizing energy
    th0=ImgTh(I,.5);
    th2=ImgTh(I,.7);
    th1=ImgTh(I,.3);
    cost=(th2-th1)/30;
    rs0=rs(1)/(rs(2)-rs(1))-1;
    energy=@(ind)contour_energy_3(ind,I,cost,rs0,edges,neighbors);
    if iframe==1 
        if isempty(nm.nuclei{1,inuc})
            [~,ini_c]=max(I,[],1);
            ini_c=ones(size(ini_c))*mean(ini_c);
        else
            ini_c=(nm.nuclei{1,inuc}.r)';
        end
    else
        ini_c=(nm.nuclei{iframe-1,inuc}.r)';
    end
    lb_c=zeros(1,size(points,1))+2;
    ub_c=zeros(1,size(points,1))+length(rs)-0.001;

    options=optimoptions('fmincon','MaxFunEvals', 1e6,'TolX',.01,'GradObj','on','Display','off');
    [indr,fval,exitflag,output] = fmincon(energy,ini_c,[],[],[],[],lb_c,ub_c,[],options);
%     display(cost);
    [~,grad,intensity,dr]=energy(indr);
    r=rs(1)+(indr-1)*(rs(2)-rs(1));
    %% update center
    x=r'.*points(:,1);
    y=r'.*points(:,2);
    z=r'.*points(:,3);
    meandcnt=[mean(x),mean(y),mean(z)/zxr];

    %% calculate volume in unit of x,y, unit
    volume=trisphere_volume([x,y,z],faces);
    %% calculate contour in each plane
    p1=edges(:,1);
    p2=edges(:,2);
    zstack=((1:10)-nuc_origin(3))*zxr;
    contour=[];
    for i=1:nm.numstacks
        istack=zstack(i);
        cross_edge=edges((z(p1)<istack & z(p2)>=istack)|(z(p1)>istack & z(p2)<=istack),:);
        z1=z(cross_edge(:,1))-istack;
        z2=istack-z(cross_edge(:,2));
        w1=z2./(z1+z2);
        w2=z1./(z1+z2);
        xi=w1.*x(cross_edge(:,1))+w2.*x(cross_edge(:,2));
        yi=w1.*y(cross_edge(:,1))+w2.*y(cross_edge(:,2));
        cx=mean(xi);
        cy=mean(yi);
        xi=xi-cx;
        yi=yi-cy;
        [theta,rho]=cart2pol(xi,yi);
        res=sortrows([theta,rho],1);
        [xi,yi]=pol2cart(res(:,1),res(:,2));
        xi=xi+cx;
        yi=yi+cy;
        if ~isempty(xi)
            xi=[xi;xi(1)];
            yi=[yi;yi(1)];
        end
        contour(i).x=xi;
        contour(i).y=yi;
        contour(i).area=polyarea(xi,yi);
    end
    
    % fit to new center using z areas
    area=zeros(1,nm.sizeZ);
    for i=1:length(area)
        area(i)=contour(i).area;
    end
    stack_fit=(-2:2)+round(nuc_origin(3));
    stack_fit=max(1,stack_fit(1)):min(10,stack_fit(end));
    area_fit=area(stack_fit);  
    stack_z=stack_fit*zxr;
    ini_g=[8,nuc_origin(3)*zxr];
    lb_g=[1,min(stack_z)];
    ub_g=[15,max(stack_z)];   
    options_sphere=optimset('TolX',5e-2,'TolFun',1e-2,'Display','off');
    gaussfit=@(P) sphere_area(P,stack_z) - area_fit;
    gfit=lsqnonlin(gaussfit,ini_g,lb_g,ub_g,options_sphere);     
    %% save data
    nuc=nm.nuclei{iframe,inuc};
    nuc.r_new=r';
%     nuc.origin=nuc_origin;
%     nuc.center=meandcnt+nuc_origin; %already correct for zxr
%     nuc.center(3)=gfit(2)/zxr;
    nuc.volume=volume;
    nuc.grad=grad;
    nuc.intensity=intensity;
    nuc.contour=contour;
    nuc.fval=fval;
    nuc.exitflag=exitflag;
    nuc.output=output;
    nuc.cost=cost;
    nm.nuclei{iframe,inuc}=nuc;

 
    %% plot all together
    %fit in ten stacks
    if 1
        f=figure(103);
        set(f,'Unit','pixels','Position',[0 50 1000 750]);
        clf
        nuc=nm.nuclei{iframe,inuc};
        img=nm.grab3(iframe);
        round_origin=round(nuc.origin_new(1:2));
        d_origin=nuc.origin_new(1:2)-round_origin;
        wimg=img(round_origin(2)-hw:round_origin(2)+hw,...
            round_origin(1)-hw:round_origin(1)+hw,:);
        
        axes('Unit','pixel','Position',[0 400 350 350]);
        pts=[nuc.r_new.*points(:,1),nuc.r_new.*points(:,2),nuc.r_new.*points(:,3)];
        TR = triangulation(faces,pts);
        trisurf(TR,'FaceColor','red','EdgeColor','black');
        axis([-15 15 -15 15 -15 15]);
        grid off
        view(3);
        daspect([1 1 1])
        camlight
        lighting gouraud

        axes('Unit','pixel','Position',[370 420 310 310]);
        intensity=nuc.intensity;
        neighbors=nm.neighbors;
        neighbors(1:12,6)=(1:12)';
        r_energy=sum((indr(neighbors)-indr'*ones(1,6)).^2,2)*cost(1);
        plot(1:length(intensity),intensity,1:length(intensity),r_energy)
        axis([0 length(intensity) 0 65535])
        legend('intensity','bending energy')

        axes('Unit','pixel','Position',[720 420 270 310]);
        area=zeros(1,nm.sizeZ);
        for i=1:length(area)
            area(i)=nuc.contour(i).area;
        end
        stack_g=(1:.1:nm.sizeZ)*zxr;
        area_g=sphere_area(gfit,stack_g);
        plot(1:length(area),area,'ob',stack_g/zxr,area_g,'r-');
        axis([0 10 0 400]);
        xlabel('stack id');
        ylabel('area (pixel^2)');
        
        for i=1:10
            xi=nuc.contour(i).x;
            yi=nuc.contour(i).y;
            pr=floor((i-1)/5);
            pc=i-5*pr-1;
            pr=1-pr;
            imgsize=200;
            axes('Unit','pixel','Position',[pc*imgsize pr*imgsize imgsize imgsize]);
            SI(wimg(:,:,i));
            hold on;
            plot(xi+hw+1+d_origin(1),yi+hw+1+d_origin(2),'-','Linewidth',2);
            axis off;
            box on;
            text(5,3,['Zstack:',num2str(i)],'Color','r','FontWeight','bold','FontSize',15);
            text(5,wsz-3,['Area:',num2str(contour(i).area)],'Color','y','FontWeight','bold','FontSize',15);
            if i==1
%                 text(5,10,[{'window center'},{['x:',num2str(nuc_wcenter(1))]},...
%                     {['y:',num2str(nuc_wcenter(2))]},{['z:',num2str(nuc_wcenter(3))]}],...
%                     'Color','m','FontWeight','bold','FontSize',15);
                text(5,10,['frame: ',num2str(iframe),' nuclei: ',num2str(inuc)],...
                    'Color','r','FontWeight','bold','FontSize',15);

                text(5,20,[{'nuc center'},{['x:',num2str(nuc.center(1))]},...
                    {['y:',num2str(nuc.center(2))]},{['z:',num2str(nuc.center(3))]}],...
                    'Color','g','FontWeight','bold','FontSize',15);
            end
        end
    end
    drawnow;
    %%
    toc
end
%%


end


