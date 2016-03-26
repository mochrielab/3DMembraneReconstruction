function next(obj)
% go next
% run all the analysis specified
% 3/26/2016 Yao Zhao

%%

% get analysis info
[analysismethods,analysisdescription,inputformats]=CellVision3D.CellAnalyzer.getCellAnalysisMethods;

% run each analysis
for ianalysis=1:size(obj.cell_analysis_handles,1)
    analysisind=get(obj.cell_analysis_handles(ianalysis,1),'Value');
    if analysisind>1
        % selected method
        analysismethod=analysismethods{analysisind};
        % number of required inputs
        numinputsrequired = length(inputformats{analysisind});
        % get input
        isvalid=1;
        inputs=cell(1,numinputsrequired);
        for iinput=1:numinputsrequired
            try
                tmphandle=obj.cell_analysis_handles(ianalysis,1+iinput);
                strings=get(tmphandle,'String');
                inputs{iinput}=strings{get(tmphandle,'Value')};
            catch
                isvalid=0;
            end
        end
        
        % check if inputs are correct 
        if isvalid
            CellVision3D.CellAnalyzer.(analysismethod)(obj.data.cells,inputs{:});
            display(['analysis done: ',analysismethod]);
        else
            warning(['analysis not valid: ',analysismethod]);
        end
        
        %
%         obj.set
    end
end


end

