classdef (Abstract) MergingInterface
    %interface of merging different type of cell measurements
    %implemented by particle, contour, membrane
    
    properties
    end
    
    methods (Abstract)
        cnt=getCentroid(obj)
    end
    
end

