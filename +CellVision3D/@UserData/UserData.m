classdef UserData < handle
    % a base class of holding user data
    % should be inherited by classes like, cell, contour, particle
    
    properties (SetAccess = private)
        userdata
    end
    
    methods
        % set userdata struct
        function setUserData (objs, fieldname, data)
            for iobj=1:numel(objs)
                objs(iobj).userdata.(fieldname)=data;
            end
        end
        
        % get userdata struct
        function datafields = getUserData(objs,fieldname)
            datafields=cell(size(objs));
            for iobj=1:numel(objs)
                datafields{iobj}=objs(iobj).userdata.(fieldname);
            end
        end
        
        % remove userdata struct
        function removeUserData(objs,fieldname)
            for iobj=1:numel(objs)
                objs(iobj).userdata.rmfield(fieldname);
            end
        end
        
        % get userdata fields
        function fields=getUserDataFieldNames (objs)
            
            fields=[];
            if ~isempty(objs)
                for iobj=1:numel(objs)
                    %                 ifieldnames = fieldnames(objs(iobj));
                    if ~isempty(objs(iobj).userdata)
                        fields=unique([fields,fieldnames(objs(iobj).userdata)]);
                    end
                end
            end
        end
    end
    
end

