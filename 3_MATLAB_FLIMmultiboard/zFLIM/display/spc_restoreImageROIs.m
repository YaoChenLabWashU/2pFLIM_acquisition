function spc_restoreImageROIs
% used from spc_drawInit in case the ROIs are still in memory
global gui FLIMchannels
try
    numROI=length(gui.gy.rois);
catch
    return
end
for nROI=1:numROI
    color=gui.gy.roiColors{mod(nROI-1,numel(gui.gy.roiColors))+1};
    posROI=gui.gy.roiPositions{nROI};
    for fc=FLIMchannels
        for t=1:2
            if ~isvalid(gui.gy.rois{nROI}.obj{fc,t})
                % need to fix the display object
                switch t
                    case 1
                        newObj=impoly(gui.spc.projects{fc}.axes,posROI);
                    case 2
                        newObj=impoly(gui.spc.lifetimeMaps{fc}.axes,posROI);
                end
                gui.gy.rois{nROI}.obj{fc,t}=newObj;
                setColor(newObj,color);
                set(newObj,'UserData',{nROI fc t posROI});
                addNewPositionCallback(newObj,@roiMovedCallback);
                % can't get much info from the callback, so instead stored the
                % original position in the UserData and use occasional calls to
                % 'spc_conformROIpositions' to reconcile the positions
            end
        end
    end
end

function roiMovedCallback(pos)
global gui 
gui.gy.roisHaveMoved=1;