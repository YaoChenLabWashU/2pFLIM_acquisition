function spc_SaveExportAnalysis(prefix)
% Save analysis information and export all to Igor
global AcqTime RecEmpLifeTime gui spc state
nROIs=size(gui.gy.roiPositions,2);
for roi=1:nROIs %%Define as global: EmpLifeTimeROI1, 2, 3, etc.
    eval(['global EmpLifeTimeROI' num2str(roi)])
    eval(['global BindFracROI' num2str(roi)])
end

% opt=spc.analysis.excelExportOptions; % get the options list

AnalysisDate=datestr(clock,29); % Get AnalysisDate to put into file names.
saveWave(AcqTime, strcat(AnalysisDate, 'AcqTime'));
saveWave(RecEmpLifeTime, strcat(AnalysisDate, 'RecEmpLifeTime'));
 for roi=1:nROIs
        if roi<=nROIs
            a=strcat('EmpLifeTimeROI', num2str(roi)); %a is file name.
            c=strcat('BindFracROI', num2str(roi)); %c is file name for binding fractions.
            eval(['saveWave(EmpLifeTimeROI' num2str(roi) ', strcat(AnalysisDate, a));']);  %Save wave for each ROI.  
            eval(['saveWave(BindFracROI' num2str(roi) ', strcat(AnalysisDate, c));']); % save binding fraction for each ROI
        end
 end
 exportAllToIgorYao(prefix, '*', 0, 1, 0,1000000)
end

