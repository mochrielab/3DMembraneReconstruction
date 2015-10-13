function [ posnew ] = SegmentLine( pos, select, varargin )
%segment a line into lines based on select vector, optional minimum
%vectorsize


if nargin==2
    minl=1;
elseif nargin==3
    minl=varargin{1};
else
    error('wrong number of input');
end

select=[0,select,0];
ds=diff(select);
startp=find(ds==1);
endp=find(ds==-1)-1;

posnew=cell(size(startp));
for i=1:length(startp)
    if endp(i)-startp(i)+1>=minl;
        posnew{i}=pos(startp(i):endp(i),:);
    end
end
posnew=posnew(cellfun(@(x)~isempty(x),posnew));


end

