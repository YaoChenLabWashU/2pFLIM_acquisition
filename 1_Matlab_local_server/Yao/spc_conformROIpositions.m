function spc_conformROIpositions
global gui FLIMchannels
if ~isfield(gui.gy,'roisHaveMoved')  || gui.gy.roisHaveMoved==0 || ~isfield(gui.gy,'rois')
    return
end
nROI=numel(gui.gy.rois);
for nr=1:nROI
    for chan=FLIMchannels
        for type=1:2
            try
                obj=gui.gy.rois{nr}.obj{chan,type};  % get the existing obj
                actualPos=getPosition(obj);
                ud=get(obj,'UserData');
                orgPos=ud{4};
                if any(size(actualPos)~=size(orgPos)) || ~all(all(actualPos==orgPos))
                    % need to update using this position
                    gui.gy.rois{nr}.mask=createMask(obj);
                    gui.gy.roiPositions{chan,nr}=actualPos; %Update gui.gy.roiPositions
                    for fc=FLIMchannels
                        for t=1:2
                            obj2=gui.gy.rois{nr}.obj{fc,t};
                            setPosition(obj2,actualPos);
                            % also update the new 'originalPos'
                            ud2=get(obj2,'UserData');
                            ud2{4}=actualPos;
                            set(obj2,'UserData',ud2);
                        end
                    end
                end
            end
        end
    end
end
gui.gy.roisHaveMoved=0;


