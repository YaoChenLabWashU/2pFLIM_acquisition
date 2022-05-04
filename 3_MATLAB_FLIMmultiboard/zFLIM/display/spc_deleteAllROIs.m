function spc_deleteAllROIs(chan)
% TODO fn needs updateing
global spc gui
% figure(gui.spc.figure.image);
s=warning('off','all');
for numROI=1:length(gui.gy.rois)
    for fc=1:4 %(can be multiple list)%Yao: changed from fc=chan to fc=1:4 so that we update all windows on 5/4/2022.
        for type=1:2
            try
                delete(gui.gy.rois{numROI}.obj{fc,type});
            end
        end
    end
    % TODO need to change this if channels have separate ROIs
    %gui.gy.rois{numROI}.obj={};
    gui.gy.rois{numROI}.mask={};
end
gui.gy.roiPositions={};
gui.gy.rois={};
spc_calculateROIvals(0);
warning(s);

% TODO here we need to redraw all windows that depend on it
% spc_redrawSetting(1);
