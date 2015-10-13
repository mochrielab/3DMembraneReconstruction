function [ bw2,img ] = edge3( bw0 ,varargin)
%find 3d edge of the 3d bw image
% bw2 is the edge bw image
% img record how many nearby zeros
%default 6 way connect
% 3/12/2015 Yao Zhao

bw1=zeros(size(bw0)+2);
bw1(2:end-1,2:end-1,2:end-1)=bw0;
img=zeros(size(bw0)+2);
if nargin==2;
    num=varargin{1};
elseif nargin==1
    num=6;
end

if num==26
    for ir=-1:1
        for ic=-1:1
            for ik=-1:1
%                 if ~(ir==0 && ic==0 && ik==0)
                img((2:end-1),(2:end-1),(2:end-1))=img((2:end-1),(2:end-1),(2:end-1))...
                    +bw1((2:end-1)+ir,(2:end-1)+ic,(2:end-1)+ik);
%                 end
            end
        end
    end
elseif num==6
    inc=[0 0 1; 0 0 -1; 0 1 0; 0 -1 0; 1 0 0; -1 0 0];
    for i=1:size(inc,1)
        ir=inc(i,1);
        ic=inc(i,2);
        ik=inc(i,3);
        img((2:end-1),(2:end-1),(2:end-1))=img((2:end-1),(2:end-1),(2:end-1))...
            +bw1((2:end-1)+ir,(2:end-1)+ic,(2:end-1)+ik);
    end
elseif num==18
    for ir=-1:1
        for ic=-1:1
            for ik=-1:1
                if (ir*ic*ik)==0 %%&& ~(ir==0 && ic==0 && ik==0)
                img((2:end-1),(2:end-1),(2:end-1))=img((2:end-1),(2:end-1),(2:end-1))...
                    +bw1((2:end-1)+ir,(2:end-1)+ic,(2:end-1)+ik);
                end
            end
        end
    end
else
    error('wrong input connection');
end
img=img(2:end-1,2:end-1,2:end-1);
bw2 = img>0 & bw0==0;
img(bw0==1)=0;

end

