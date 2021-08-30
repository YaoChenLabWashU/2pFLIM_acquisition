function spc_configureExcelExport
global spc FLIMchannels
% set up the column labels, according to the options set in the 
% ExcelExportConfig dialog

t=spc.analysis.excelExportOptions;
labels={'filename', 'acq time','filenum','nmLaser','power'};

if t.ROIvals
    for ch=1:2
        for roi=1:t.maxROIs
            labels{end+1}=['Img' num2str(ch) ':' num2str(roi)];
        end
    end
end

for fc=FLIMchannels  % everything else is repeated per FLIM channel
    labels{end+1}=[num2str(fc) 'LifeEmpir'];
    if t.ROIlife
        for roi=1:t.maxROIs
            labels{end+1}=[num2str(fc) 'Life' num2str(roi)];
        end
    end
    if t.ROImean
        for roi=1:t.maxROIs
            labels{end+1}=[num2str(fc) 'Mean' num2str(roi)];
        end
    end
    if t.ROIcount
        for roi=1:t.maxROIs
            labels{end+1}=[num2str(fc) 'Count' num2str(roi)];
        end
    end
    labels{end+1}=[num2str(fc) 'FigOffset'];
    labels{end+1}=[num2str(fc) 'FitStart'];
    labels{end+1}=[num2str(fc) 'FitEnd'];
    
    if t.fitDetails
        labels(numel(labels)+(1:13))={'type' 'order' 'redChiSq' 'a1' 't1' 'a2' 't2'...
            'delX' 'gauss' 'pop1' 'pop2' 'avgTau' 'avgTauTrunc'};
    end
end % for fc=FLIMchannels
% TODO - gy make more sensible choices of how many std ROI cols to include
if t.stdROIs
    for ch=[1 2 4 5]  % just to be safe
        for roi=1:t.maxROIs
            labels{end+1}=['Img' num2str(ch) ':std' num2str(roi)];
        end
    end
end
spc.analysis.excelExportOptions=t;
spc.analysis.fieldsForExcelLabels=labels;
