function roiDataStruct = translateROIData
global gui
roiData=gui.ROI.roiData;
nrois = size(roiData,1);
nchan = size(roiData,2);
npts  = size(roiData,4);

for nr=1:nrois
    for ch=1:nchan
        roiDataStruct.intensity{nr,ch}=squeeze(roiData(nr,ch,1,:));
        roiDataStruct.lifetime{nr,ch}=squeeze(roiData(nr,ch,2,:));
    end
end

roiDataStruct.timebase = minutes(gui.ROI.xValsForROIPlots - gui.ROI.xValsForROIPlots(1));


        