function [ np ] = decide_double( np)
%decide if nuclei have single or double particles
for inuc=1:np.num_nuc
    p=np.particle{1,inuc};
    %absolutely out
    solid_isout=p.min_dist<-.4;
    if solid_isout(1)&&sum(solid_isout(2:4))
        %both result out
        p.isdouble=[];
    elseif solid_isout(1)
        %particle 1 is out
        p.isdouble=1;
    elseif sum(solid_isout(2:4))
        %particle pair isout
        p.isdouble=0;
    elseif p.resnorm_windowed(2)<p.resnorm_windowed(1)-0.005...
            && min(p.particle2.brightness)/max(p.particle2.brightness)>0.7
%             && p.seperation>0.1
        %pair fit is better, and brightness are close, and distance are far
        p.isdouble=1;
    else
        p.isdouble=0;
    end
    np.particle{1,inuc}.isdouble=p.isdouble;
    if p.isdouble~=1
        np.particle{1,inuc}.seperation=0;
    end
end

end

