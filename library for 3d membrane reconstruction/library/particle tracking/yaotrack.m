
function [trj_final]=yaotrack(pos,tparam)
%build trajectories
%input: pos,param
% pos contains: x y z . . . . t
% param contains: dim, mem, good, show
%6/30/2014 Yao


%%
%sort positions by time orders
% pos=sortrows(pos,size(pos,2));
dim=tparam.dim;
maxdisp=tparam.maxdisp;
mem=tparam.mem;
good=tparam.good;
numcol=size(pos,2);%number of columns of pos

ts=pos(:,end);
tsu=unique(ts);
trj=pos(ts==ts(1),:);
trj=[trj,(1:size(trj,1))'];
trjends=trj;
numtrj=size(trj,1);

for itsu=2:length(tsu)
    iframe=tsu(itsu);
    %find trjectory ends
    trjends=[];
    for itrj=1:numtrj
        trjtmp=trj(trj(:,numcol+1)==itrj,:);
        trjends=[trjends;trjtmp(end,:)];
    end
    % find ends that is within number of memory
    trjends=trjends(trjends(:,numcol)+1+mem>=iframe,:);
    ltrjends=size(trjends,1);
    % new points to be added
    newpos=pos(ts==iframe,:);
    lnewpos=size(newpos,1);
    
    %if trjend is empty , start new trajectori
    if isempty(trjends)
        trj=[trj;newpos,(1:size(newpos,1))'+numtrj];
        numtrj=numtrj+size(newpos,1);
    else %add particle to new trj
        %calculate position distance matrix
        dist2=zeros(ltrjends,lnewpos);
        if ltrjends>0
            for idim=1:dim
                [p1,p2]=meshgrid(newpos(:,idim),trjends(:,idim));
                dist2=dist2+(p1-p2).^2;
            end
        end
        
        % minimize the connection
        isconn=dist2<maxdisp^2;
        %use connection2 to record avaible connection index of each trajectory
        isconn2=nan(size(isconn));
        for iisconn=1:size(isconn,1)
            tmparray=find(isconn(iisconn,:));
            isconn2(iisconn,1:length(tmparray))=tmparray;
        end
        
        % remove unconnected trj
        contrj=find(sum(isconn,2)>0);
        noncontrj=find(sum(isconn,2)==0);
        ltrjends=length(contrj);
        dist2=dist2(contrj,:);
        isconn=isconn(contrj,:);
        isconn2=isconn2(contrj,:);
        if ~isempty(contrj)
            %find minimum energy combination among all possible combination
            comb_arraysize=(sum(isconn,2)+1)';
            comb_total=prod(comb_arraysize);
            comb_value=zeros(comb_total,1);
            ind_array_cell=cell(1,ltrjends);
            for icomb=1:comb_total
                %combinination i
                [ind_array_cell{1:ltrjends}]=ind2sub(comb_arraysize,icomb);
                ind_array=cell2mat(ind_array_cell)-1;
                %trjectories connected list
                trj_con=find(ind_array>0);
                %position connected list
                pos_con=isconn2(sub2ind([ltrjends,lnewpos],trj_con,ind_array(trj_con)));
                pos_con=reshape(pos_con,1,length(pos_con));
                %distance2 of each connection
                if ~isempty(trj_con) && length(pos_con)==length(unique(pos_con))
                    dist2_ind=sub2ind([ltrjends,lnewpos],trj_con,pos_con);
                    comb_value(icomb)=sum(dist2(dist2_ind))+(ltrjends-length(trj_con))*maxdisp^2*2;
                else
                    comb_value(icomb)=ltrjends*maxdisp^2*2;
                end
            end
            
            %minimum combination
            min_array_cell=cell(ltrjends,1);
            [~,ind_min]=min(comb_value);
            [min_array_cell{1:ltrjends}]=ind2sub(comb_arraysize,ind_min);
            min_array=cell2mat(min_array_cell)-1;
            
            %add connected points to trj
            trj_con_min=find(min_array>0);
            pos_con_min=isconn2(sub2ind([ltrjends,lnewpos],trj_con_min,min_array(trj_con_min)));
            trj_con_ind=trjends(contrj(trj_con_min),numcol+1);
            trj=[trj;newpos(pos_con_min,:),trj_con_ind];
            
            %add unconnected points to trj
            newtrj=ones(lnewpos,1);
            newtrj(pos_con_min)=0;
            newtrj=find(newtrj);
            trj=[trj;newpos(newtrj,:),(1:length(newtrj))'+numtrj];
            numtrj=numtrj+length(newtrj);
        else
            %add unconnected points to trj
            trj=[trj;newpos,(1:size(newpos,1))'+numtrj];
            numtrj=numtrj+size(newpos,1);
        end

    end
end

% clean up the trj
trj_final=[];
for itrj=1:trj(end,numcol+1)
    trjtmp=trj(trj(:,numcol+1)==itrj,:);
    if size(trjtmp,1)>=good
        trj_final=[trj_final;trjtmp];
    end
end

