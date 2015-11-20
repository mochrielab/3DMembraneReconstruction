function [numStacks,numFrames,iStack,iFrame]=GetMovieInfo(s)
% exctract info from movie format [numStacks,numFrames,iStack,iFrame]=GetMovieInfo(s)
[token,remain]=strtok(s,' ;');
while ~isempty(token)
    z=strfind(token,'Z=');
    t=strfind(token,'T=');
    if ~isempty(z)
        [token1,remain1]=strtok(token,'/;');
        numStacks=strtok(remain1,'/');
        [~,token1]=strtok(token1,'=');
        iStack=strtok(token1,'=');
        numStacks=str2num(numStacks);
        iStack=str2num(iStack);
    else
        iStack=1;
        numStacks=1;
    end
    if ~isempty(t)
        [token1,remain1]=strtok(token,'/;');
        numFrames=strtok(remain1,'/');
        [~,token1]=strtok(token1,'=');
        iFrame=strtok(token1,'=');
        numFrames=str2num(numFrames);
        iFrame=str2num(iFrame);
    else
        numFrames=1;
        iFrame=1;
    end
    [token,remain]=strtok(remain,';');
end


end