function [ image3, mesh, contour, meshnoise] = SimulateZStacks(varargin)
% simulate a z-stack of images



% configure fluctuation parameter
wz=51;
mw=(wz+1)/2;
nz=7.5;
cz=nz+5+1.2;
image3=zeros(wz,wz,wz);
theta=pi/4;
thetadecay = pi/6;
if nargin == 0
    amp = 0;
else
    amp = varargin{1};
end

% generate mesh for surface
[mesh.vertices,mesh.faces]=TriSphere(3);
mesh.vertices= mesh.vertices*nz + ...
    amp./(1+(acos(mesh.vertices*[cos(theta),sin(theta),0]'*[1 1 1])).^2/thetadecay^2)+mw;
d= amp./(1+(acos(mesh.vertices*[cos(theta),sin(theta),0]'*[1 1 1])).^2/thetadecay^2);
% generate mid plane contour
t=linspace(0,2*pi,2^12+1);
t=t(1:end-1);
r1=nz+ amp./(1+(acos(cos(t)*cos(theta)+sin(t)*sin(theta))).^2/thetadecay^2);
contour.x= r1 .* cos(t) + mw;
contour.y= r1 .* sin(t) + mw;


% generate by random sampling
% for i=1:1.8e3
%     rx = rand(1)*2-1;
%     ry = (rand(1)*2-1);
%     rz = rand(1)*2-1;
%     r=sqrt(rx^2+ry^2+rz^2);
%     n=[rx,ry,rz]/r;
%     if r <= 1
%         d= amp * exp(-(acos(n*[cos(theta),sin(theta),0]')/thetadecay).^2);
% %         d= amp./(1+(acos(n*[cos(theta),sin(theta),0]')).^2/thetadecay^2);
%
%         x=rx/r*(nz+d)+mw;
%         y=ry/r*(nz+d)+mw;
%         z=rz/r*(nz+d)+mw;
%         cnt=round([x,y,z]);
%         [xs,ys,zs]=meshgrid(-x+cnt(1)+(-3:3),-y+cnt(2)+(-3:3),-z+cnt(3)+(-3:3));
%         wimg3 = exp(-1/1.25*((xs).^2+(ys).^2+(zs/1.5).^2 ));
% %         wimg3 = wimg3 + 0.2*wimg3.*randn(7,7,7);
%         image3(cnt(2)+(-3:3),cnt(1)+(-3:3),cnt(3)+(-3:3)) = ...
%             image3(cnt(2)+(-3:3),cnt(1)+(-3:3),cnt(3)+(-3:3)) + (.125+d/nz+abs(randn(1)))*wimg3;
%     end
% end
for i=1:size(mesh.vertices,1)
    x=mesh.vertices(i,1);
    y=mesh.vertices(i,2);
    z=mesh.vertices(i,3);
    cnt=round([x,y,z]);
    [xs,ys,zs]=meshgrid(-x+cnt(1)+(-3:3),-y+cnt(2)+(-3:3),-z+cnt(3)+(-3:3));
    wimg3 = exp(-1/3*((xs).^2+(ys).^2+(zs/1.5).^2 ));
    image3(cnt(2)+(-3:3),cnt(1)+(-3:3),cnt(3)+(-3:3)) = ...
        image3(cnt(2)+(-3:3),cnt(1)+(-3:3),cnt(3)+(-3:3)) + (20*(d(i)-min(d(:)))^2/nz^2+abs(randn(1))^1.5)*wimg3;
end

% add cell body
image3=image3/max(image3(:));
[x,y,z]=meshgrid(1:wz,1:wz,1:wz);
r=sqrt((y-mw).^2+(z-mw).^2+(x-mw).^2 /4);
mask=r<(cz+4);
r2=sqrt((y-mw).^2+(z-mw).^2+(x-mw).^2);
nz2=nz+8;
mask=.7*exp(-((r)/cz).^2)+.3*exp(-(r2/cz).^2).*mask;



% add noise to the system
image3 = .75*image3 + .11 + .55*mask;
image3 = .20*image3 + 0.015*rand(wz,wz,wz) + 0.010*randn(wz,wz,wz).*image3 + 0.00*randn(wz,wz,wz).*sqrt(image3);

% add noise to mesh
[meshnoise.vertices,meshnoise.faces]=TriSphere(3);
meshnoise.vertices= meshnoise.vertices.*(1.05+.05*randn(size(meshnoise.vertices)))*nz + ...
    amp./(1+(acos(meshnoise.vertices*[cos(theta),sin(theta),0]'*[1 1 1])).^2/thetadecay^2)+mw;

end

