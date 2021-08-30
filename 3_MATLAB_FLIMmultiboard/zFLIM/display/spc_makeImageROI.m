function spc_makeImageROI(chan,type)
% type=1 for projectN figure, =2 for lifetimeMap figure
% not used right now, but could be if we decide not to duplicate in all
% figs
global gui FLIMchannels
%gui.gy.roiColors='rmgwoy';
gui.gy.roiColors={'r' 'm' [0 .7 0] 'w' [1 0.5 0] 'y'};
try
    numROI=length(gui.gy.rois)+1;
catch
    numROI=1;
end
color=gui.gy.roiColors{mod(numROI-1,numel(gui.gy.roiColors))+1};
% figure(gui.spc.figure.image);  NOW MAKE ON CURRENT FIGURE
thisObj=impoly;
%gui.gy.rois{numROI}.obj{chan,type}=thisObj;
gui.gy.rois{numROI}.mask=createMask(thisObj);
%set(thisObj,'UserData',{numROI chan type});
%setColor(thisObj,color);
posROI=getPosition(thisObj);
gui.gy.roiPositions{numROI}=posROI;
delete(thisObj);  % makes it easier to duplicate later without making an extra

for fc=FLIMchannels
    for t=1:2
        switch t
            case 1
                newObj=impoly(gui.spc.projects{fc}.axes,posROI);
            case 2
                newObj=impoly(gui.spc.lifetimeMaps{fc}.axes,posROI);
        end
        gui.gy.rois{numROI}.obj{fc,t}=newObj;
        setColor(newObj,color);
        set(newObj,'UserData',{numROI fc t posROI});
        addNewPositionCallback(newObj,@roiMovedCallback);
        % can't get much info from the callback, so instead stored the
        % original position in the UserData and use occasional calls to
        % 'spc_conformROIpositions' to reconcile the positions
    end
end
spc_calculateROIvals(0);  % non-verbose

function roiMovedCallback(pos)
global gui 
gui.gy.roisHaveMoved=1;