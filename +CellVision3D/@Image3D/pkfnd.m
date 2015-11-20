function [ mx ] = pkfnd( im,th,sz )
%find peak of particles in 3d image stacks

[nr,nc,nz]=size(im);
mx=[];
if length(sz)==1
    sz1=sz(1);
    sz2=sz(1);
elseif length(sz)==2
    sz1=sz(1);
    sz2=sz(2);
end
if sz1<1
    warning('reset size to 1');
    sz1=1;
end
if sz2<1
    warning('reset size to 1');
    sz2=1;
end
if isempty(find(im>th,1))
    warning('no particle above threshold');
end

[x,y,z]=meshgrid(-sz1:sz1,-sz1:sz1,-sz2:sz2);
r=sqrt(x.^2/sz1^2+y.^2/sz1^2+z.^2/sz2^2);
indfind=find(r<=1);
[indr,indc,indz]=ind2sub(size(r),indfind);
mindex=(1+length(indfind))/2;

im2=zeros(2*sz1+nr,2*sz1+nc,2*sz2+nz)-inf;
im2(sz1+1:sz1+nr,sz1+1:sz1+nc,sz1+1:sz1+nz)=im;
% mindex=[];
for iz=sz2+1:sz2+nz%1+sz2:nz-sz2
    for ic=sz1+1:sz1+nc%sz1+1:nc-sz1
        for ir=sz1+1:sz1+nr%sz1+1:nr-sz1
            if im2(ir,ic,iz)>th 
                indl=sub2ind(size(im2),ir+indr-sz1-1,ic+indc-sz1-1,iz+indz-sz2-1);
                wim=im2(indl);
                [~,ind]=max(wim);
                if ind==mindex ...
                    mx=[mx;ic-sz1,ir-sz1,iz-sz2,im2(ir,ic,iz)];
                end
            end
        end
    end
end




% % mindex=[];
% for iz=1:nz%1+sz2:nz-sz2
%     for ic=1:nc%sz1+1:nc-sz1
%         for ir=1:nr%sz1+1:nr-sz1
%             if im(ir,ic,iz)>th 
%                 ry=max(ir-sz1,1):min(ir+sz1,nr);
%                 rx=max(ic-sz1,1):min(ic+sz1,nc);
%                 rz=max(iz-sz2,1):min(iz+sz2,nz);
%                 wim=im(ry,rx,rz);
%                 [~,ind]=max(wim(:));
% %                 [~,indsub]=max(wim);
% %                 ind=sub2ind(size(wim),indsub(1),indsub(2),indsub(3));
% %                 if isempty(mindex)
% %                     mindex=(1+length(wim(:)))/2;
% %                 end
%                 mindex=sub2ind(size(wim),ir-ry(1)+1,ic-rx(1)+1,iz-rz(1)+1);
%                 if ind==mindex ...
%                     mx=[mx;ic,ir,iz,im(ir,ic,iz)];
%                 end
%             end
%         end
%     end
% end

% out(:,1)=mx(:,2);
% out(:,2)=mx(:,1);
% out(:,3)=mx(:,3);
% out(:,4)=mx(:,4);

end

