function WriteDataToWave
global RecEmpLifeTime AcqTime gui spc %ROImasks records where the individual ROIs are for each acquisition file.
nROIs=size(gui.gy.roiPositions,2);
spc.shifted=zeros(1,nROIs); % establish shifted to record whether ROI position has been shifted.
for roi=1:nROIs %Define as global: EmpLifeTimeROI1, 2, 3, etc.
    eval(['global EmpLifeTimeROI' num2str(roi)])
    eval(['global BindFracROI' num2str(roi)])
end

opt=spc.analysis.excelExportOptions;

% Create waves and plot them.
% Rectangle empirical lifetime.
waveo('RecEmpLifeTime', nan(1,1000));
for n=1:1000
    eval(['RecEmpLifeTime.UserData.File' num2str(n) 'roiPositions=repmat({NaN},1,6);']); % Occupy ROI mask information with NaN for now.
end
waveo('AcqTime', nan(1,1000));
h=plotxy(AcqTime, RecEmpLifeTime, 'Marker', 'o');

% gyROIs.
for roi=1:nROIs
    a=strcat('EmpLifeTimeROI', num2str(roi)); %empirical lifetimeROI
    waveo(a, nan(1, 1000));
    c=strcat('BindFracROI', num2str(roi)); %Binding fraction for each ROI.
    waveo(c, nan(1, 1000));
    h=plotxy(AcqTime, a, 'Marker', '+'); % plot average tau over time.
    h=plotxy(AcqTime, c, 'Marker', '*'); % plot binding fraction over time.
end

TotalFigures=2*nROIs+1;
width=1600/(nROIs+1);
counter=0;
for n=4:TotalFigures+3
    hFig=figure(n);
    if mod(n,2)==0
        set(hFig, 'Position', [-1600+counter 100 width 300]);
        counter=counter+width;
    else
        set(hFig, 'Position', [-1600+counter 500 width 300]);
    end
end
    

